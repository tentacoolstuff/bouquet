import time
from ctypes import *
import socket
import string
import psycopg2
import datetime
import argparse

DANDELION_DEVICE = 1
SUNFLOWER_DEVICE = 2

class FR1_PAYLOAD(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte), 
                ("device_type", c_ubyte),
                ("address", c_ubyte * 4),
                ("payload", c_ubyte * 256)]
    
    def __init__(self):
        self.report_id = 0x01
        
    def __str__(self):
        data_str = ""
        for byte in self.payload:
            data_str += "0x%02x " % byte
        return "address = 0x%08x, payload = \n %s" % (self.get_address(), data_str)
    
    def set_device(self, type):
        self.device_type = type
    
    def set_address(self, address):
        self.address[3] = (address >> 24) & 0xFF
        self.address[2] = (address >> 16) & 0xFF
        self.address[1] = (address >> 8) & 0xFF
        self.address[0] = address & 0xFF
        
class FR2_START(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte), 
                ("device_type", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x02
        
    def set_device(self, type):
        self.device_type = type
 
class FR3_VALIDATE(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte), 
                ("device_type", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x03
        
    def set_device(self, type):
        self.device_type = type

class FR4_EXIT_MODE(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x04

class FR5_ACK(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x05

class FR6_NACK(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x06
        
class FR7_END(Structure):
    _pack_ = True
    _fields_ = [("report_id", c_ubyte)]
    
    def __init__(self):
        self.report_id = 0x07

class SensorReport():
    moist1   = 0.0
    moist2   = 0.0
    moist3   = 0.0
    temp1    = 0
    temp2    = 0
    temp3    = 0
    airhumid = 0.0
    batt     = 100.0
    time     = 0
    uuid     = "983d3578-3178-42fb-964f-fd57af189242"
    
    def __str__(self):
        return "Time: %d, Temp: %d, Moist: %f" % (self.time, self.temp1, self.moist2)
        
class SunflowerTCP:
    sock = None
    
    sunflower_image_size = 256 * 1024
    dandelion_image_size = 128 * 1024
    
    def __init__(self, addr, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(3)
        self.sock.connect((addr, port))
        # clear the input buffer
        self.sock.recv(100)
    
    def open_valve(self, valve):
        self.sock.sendall("vo %d\r\n" % (valve))
    
    def close_valve(self, valve):
        self.sock.sendall("vc %d\r\n" % (valve))
        
    def dandelion_polling_broadcast(self, polling):
        self.sock.sendall("p %d\r\n" % (polling))
    
    def get_report_buffer(self):
        self.sock.sendall("r\r\n");
        
        data = self.sock.recv(1024)
        print(data)
        
        strings = data.split("DREP:  ")
        
        reports = []
        for s in strings:       
            comp = s.split(",")
            
            if len(comp) != 10:
                continue

            rep_buff = SensorReport()
            rep_buff.moist2 = float(comp[3])
            rep_buff.temp1 = int(comp[9])
            rep_buff.time = int(comp[1])
            
            print(rep_buff)
            
            reports.append(rep_buff)
            
        return reports
    def set_timestamp(self, timestamp):
        self.sock.sendall("ts %d\r\n" % timestamp)
        
    def send_tcp_payload(self, fr):
        tcp_buffer = (c_ubyte * sizeof(fr))()
        memmove(tcp_buffer, byref(fr), sizeof(fr))
        self.sock.sendall(tcp_buffer)
        
        if self.get_tcp_ack() != True:
            print "TCP did not ACK!"
            exit()
    
    def get_tcp_ack(self):
        data = self.sock.recv(1)
        if (ord(data) == 6):
            print "NAK received!"
            
        return (ord(data) == 5)
    
    def enter_fw_update_mode(self):
        self.sock.sendall("mf\r\n")
        
    def exit_fw_update_mode(self):
        pack = FR7_END()
        self.send_tcp_payload(pack)
        
        pack = FR4_EXIT_MODE()
        self.send_tcp_payload(pack)
    
    def shutdown(self):
        self.sock.close()

def sunflower_image_memory_test(sf):

    sf.enter_fw_update_mode()
    
    time.sleep(0.5)
    
    fr = FR2_START()
    fr.set_device(SUNFLOWER_DEVICE)
    sf.send_tcp_payload(fr)
    
    time.sleep(0.5)
    
    address = 0x00000000
    while address < SunflowerTCP.sunflower_image_size:
        fr = FR1_PAYLOAD()
        fr.set_device(SUNFLOWER_DEVICE)
        fr.set_address(address)
        for j in range(0, len(fr.payload)):
            fr.payload[j] = 1 << 2
        
        sf.send_tcp_payload(fr)
        
        address += len(fr.payload)
        
        print "Wrote address %d" % (address)
    
    sf.exit_fw_update_mode()

def sunflower_image_download(sf, filename):

    sf.enter_fw_update_mode()
    
    time.sleep(0.5)
    
    fr = FR2_START()
    fr.set_device(SUNFLOWER_DEVICE)
    sf.send_tcp_payload(fr)
    
    time.sleep(0.5)
    
    sunflower_fw = open(filename, "rb")
    
    address = 0x00000000
    while address < SunflowerTCP.sunflower_image_size:
        fr = FR1_PAYLOAD()
        fr.set_device(SUNFLOWER_DEVICE)
        fr.set_address(address)
        fw_bytes = bytearray(sunflower_fw.read(len(fr.payload)))
        
        # pad the fw_bytes array out to the required length
        fw_bytes += "\0" * (len(fr.payload) - len(fw_bytes))
        
        for j in range(0, len(fr.payload)):
            fr.payload[j] = fw_bytes[j]
        
        sf.send_tcp_payload(fr)
        
        address += len(fr.payload)
        
        print "Wrote address %d" % (address)
    
    sf.exit_fw_update_mode()
    
def dandelion_image_memory_test(sf):

    sf.enter_fw_update_mode()
    
    time.sleep(0.5)
    
    fr = FR2_START()
    fr.set_device(DANDELION_DEVICE)
    sf.send_tcp_payload(fr)
    
    time.sleep(0.5)
    
    address = 0x00000000
    while address < SunflowerTCP.dandelion_image_size:
        fr = FR1_PAYLOAD()
        fr.set_device(DANDELION_DEVICE)
        fr.set_address(address)
        for j in range(0, len(fr.payload)):
            fr.payload[j] = 1 << 2
        
        sf.send_tcp_payload(fr)
        
        address += len(fr.payload)
        
        print "Wrote address %d" % (address)
    
    sf.exit_fw_update_mode()

def dandelion_image_download(sf, filename):

    sf.enter_fw_update_mode()
    
    time.sleep(0.5)
    
    fr = FR2_START()
    fr.set_device(DANDELION_DEVICE)
    sf.send_tcp_payload(fr)
    
    time.sleep(0.5)
    
    dandelion_fw = open(filename, "rb")
    
    address = 0x00000000
    while address < SunflowerTCP.dandelion_image_size:
        fr = FR1_PAYLOAD()
        fr.set_device(DANDELION_DEVICE)
        fr.set_address(address)
        fw_bytes = bytearray(dandelion_fw.read(len(fr.payload)))
        
        # pad the fw_bytes array out to the required length
        fw_bytes += "\0" * (len(fr.payload) - len(fw_bytes))
        
        for j in range(0, len(fr.payload)):
            fr.payload[j] = fw_bytes[j]
        
        sf.send_tcp_payload(fr)
        
        address += len(fr.payload)
        
        print "Wrote address %d" % (address)
    
    sf.exit_fw_update_mode()
    
if __name__ == '__main__':
    
    # parse arguments
    parser = argparse.ArgumentParser(description='Sunflower TCP/IP interface tool')
    parser.add_argument("--ip", help="the Sunflower IP to connect to", action="store", default="192.168.1.2", required=False)
    parser.add_argument("--port", help="Sunflower communication port", action="store", default="1337", required=False)
    parser.add_argument("--open", help="open valve X", action='store', default=None, required = False)
    parser.add_argument("--close", help="close valve X", action='store', default=None, required=False)
    parser.add_argument("--report_poll", help="Poll sunflower for reports", action='store_true', required=False)
    parser.add_argument("--change_polling_rate", help="Send a broadcast message to change the sensor polling rate", action="store", required=False)
    parser.add_argument("--dandelion_upgrade", help="Send a dandelion update to Sunflower", action="store", required=False)
    parser.add_argument("--dandelion_test", help="Perform a test dandelion upgrade", action="store_true", required=False)
    parser.add_argument("--sunflower_test", help="Perform a test sunflower upgrade", action="store_true", required=False)
    parser.add_argument("--sunflower_upgrade", help="Send a sunflower update to Sunflower", action="store", required=False)
    args = parser.parse_args()
    
    print("Connecting to Sunflower...")
    sf = SunflowerTCP(args.ip, int(args.port))
    
    print "Connected"
    
    t = int(time.time())
        
    #set unix time on the device
    print "Setting time"
    sf.set_timestamp(t)
    
    time.sleep(0.5)
    
    if args.open:
        sf.open_valve(int(args.open))
        
    if args.close:
        sf.close_valve(int(args.close))
    
    if args.change_polling_rate:
        sf.dandelion_polling_broadcast(int(args.change_polling_rate))
        
    if args.report_poll:
        print("Connecting to Database...")
        
        conn = psycopg2.connect(dbname="postgres", host="localhost", user="postgres", password="autom8")
    
        while True:
            time.sleep(2)
            reports = sf.get_report_buffer()
            print "Report transact:"
            print(reports)
            for rep in reports:
                cur = conn.cursor()
                fancytime = datetime.datetime.fromtimestamp(rep.time).strftime('%Y-%m-%d %H:%M:%S')
                cur.execute("INSERT INTO reports(moisture1, moisture2, moisture3, humidity, temperature1, temperature2, temperature3, batterylevel, reporttime, dandelionid, stateid) VALUES(0.0,%s,0.0,0.0,%s,0,0,99.0,%s,%s,1)", (str(rep.moist2), str(rep.temp1), fancytime, rep.uuid))
                conn.commit()
                cur.execute("SELECT moisturelimit FROM dandelions WHERE id='{0}'".format(rep.uuid))
                mlim = cur.fetchone()[0]
                if (rep.moist2 < mlim):
                    #values are hard-coded for the demo
                    cur.execute("INSERT INTO valve_Reports(valveid, reporttime, valvestatusid) VALUES(ARRAY['2','n','d','c'],fancytime,1)")
                    #better water command needed
                    sf.open_valve(1)
                    conn.commit()
                    time.sleep(5)
                    sf.close_valve(1)
        conn.close()        
    
    if args.dandelion_test:
        dandelion_image_memory_test(sf)
    
    if args.sunflower_test:
        sunflower_image_memory_test(sf)
    
    if args.dandelion_upgrade:
        dandelion_image_download(sf, args.dandelion_upgrade)
        
    if args.sunflower_upgrade:
        sunflower_image_download(sf, args.sunflower_upgrade)   
        
    sf.shutdown()