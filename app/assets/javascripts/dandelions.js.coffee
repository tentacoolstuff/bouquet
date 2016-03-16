# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
	url = window.location.href
	console.log(url)
	id = url.split('/').reverse()
	num = 14
	heatmapState = false
	
	$('#toggle-daily').on 'click', ->
		console.log('clicked on daily')
		num = 72;
		initViz(id[0],num)

	$('#toggle-weekly').on 'click', ->
		console.log('clicked on weekly')
		num = 7;
		initViz(id[0],num)

	$('#toggle-monthly').on 'click', ->
		console.log('clicked on monthly')
		num = 30;
		initViz(id[0],num)

	$('#toggle-grid').on 'click', ->
		$('#dandelion-view').removeClass('list-view').addClass('grid-view')
		$(this).addClass('opacityUp')
		$('#toggle-list').removeClass('opacityUp')

	$('#toggle-list').on 'click', ->
		$('#dandelion-view').removeClass('grid-view').addClass('list-view')
		$(this).addClass('opacityUp')
		$('#toggle-grid').removeClass('opacityUp')

	#show markers on hover 

	$('.dandelion-listing-item').hover ->
		if !heatmapState
			hideMessages()
			op = $('.dandelion-listing-item').index(this)
			showMessage(markerList[op],op)

	$('.data-nav-li').on 'click', ->
		$('.data-nav-li	').removeClass('active')
		$(this).addClass('active')
		if $(this).hasClass('menu-heatmap')
			showHeatMap()
			hideMarkers()
			hideMessages()
			heatmapState = true
		else
			hideHeatMap()
			showMarkers()			
			heatmapState = false

	initViz(id[0],num)


$(document).ready(ready)
$(document).on('page:load', ready)