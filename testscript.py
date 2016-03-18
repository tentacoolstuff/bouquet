import psycopg2

print("Connecting to Database...")
    
#conn = psycopg2.connect(dbname="postgres", host="localhost", user="postgres", password="autom8")
#cur = conn.cursor()

for i in range(0,9):
  conn = psycopg2.connect(dbname="postgres", host="localhost", user="postgres", password="autom8")
  cur = conn.cursor()
  cur.execute("INSERT INTO valve_Reports(valveid, reporttime, valvestatusid) VALUES(ARRAY['2','n','d','c'],'2016-03-16 17:02:18-04',1)")
  conn.commit()
  conn.close()
  #cur.execute("INSERT INTO reports(moisture1, moisture2, moisture3, humidity, temperature1, temperature2, temperature3, batterylevel, reporttime, dandelionid, stateid) VALUES(0.0,%s,0.0,0.0,%s,0,0,99.0,%s,%s,1)", (str(rep.moist2), str(rep.temp1), fancytime, rep.uuid))

#conn.close()
