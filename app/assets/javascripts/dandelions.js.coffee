# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
	$('#toggle-grid').on 'click', ->
		$('#dandelion-view').removeClass('list-view').addClass('grid-view')
		$(this).addClass('opacityUp')
		$('#toggle-list').removeClass('opacityUp')

	$('#toggle-list').on 'click', ->
		$('#dandelion-view').removeClass('grid-view').addClass('list-view')
		$(this).addClass('opacityUp')
		$('#toggle-grid').removeClass('opacityUp')
	
	url = window.location.href
	console.log(url)
	id = url.split('/').reverse()


	initViz(id[0])

$(document).ready(ready)
$(document).on('page:load', ready)