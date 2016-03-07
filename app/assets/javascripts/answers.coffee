# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




$ ->
  $(".btn").on "click", ->
    $(@).toggleClass("btn-danger")


capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

titleize = (string) ->
  words = string.split(" ")
  words = words.map (word)-> capitalize(word)
  console.log(words)
  words.join(" ")


$ ->
  $(".input-something").on "keyup", ->
    text = $(@).val()
    $("#thisDiv").html(titleize(text))
