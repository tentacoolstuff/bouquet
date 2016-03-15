# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
	url = window.location.href
	console.log(url)
	id = url.split('/').reverse()
	num = 15
	
	$('#toggle-daily').on 'click', ->
		console.log('clicked on daily')
		num = 10;
		initViz(id[0],num)

	$('#toggle-weekly').on 'click', ->
		console.log('clicked on weekly')
		num = 4;
		initViz(id[0],num)

	$('#toggle-monthly').on 'click', ->
		console.log('clicked on monthly')
		num = 1;
		initViz(id[0],num)

	$('#toggle-grid').on 'click', ->
		$('#dandelion-view').removeClass('list-view').addClass('grid-view')
		$(this).addClass('opacityUp')
		$('#toggle-list').removeClass('opacityUp')

	$('#toggle-list').on 'click', ->
		$('#dandelion-view').removeClass('grid-view').addClass('list-view')
		$(this).addClass('opacityUp')
		$('#toggle-grid').removeClass('opacityUp')
	
	initViz(id[0],num)
	# initMois(num)
	



$(document).ready(ready)
$(document).on('page:load', ready)