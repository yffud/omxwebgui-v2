'use strict'

var owg = {}

// some values that will be set in the main layout view
owg.translations = {}
owg.language = ''
owg.rootUrl = ''
owg.folders = []
owg.settings = {}
owg.version = ''

$(document).ready(function () {

  // do some hamburger and navigation magic
  var trigger = $('.hamburger'),
    overlay = $('.overlay'),
    isClosed = false

  trigger.click(function () {
    hamburger_cross()
  })

  function hamburger_cross () {

    if (isClosed) {
      overlay.hide()
      trigger.removeClass('is-open')
      trigger.addClass('is-closed')
      isClosed = false
    } else {
      overlay.show()
      trigger.removeClass('is-closed')
      trigger.addClass('is-open')
      isClosed = true
    }
  }

  $('[data-toggle="offcanvas"]').click(function () {
    $('#wrapper').toggleClass('toggled')
  })

  // init selectpicker
  $('.selectpicker').selectpicker()

  // remove the page-container spinner and show content
  $('.spinner-container').remove()
  $('.page-content').removeClass('hidden')

  checkForUpdate(function (data) {
    if (data && data.version !== owg.version) {
      $('.top-logo .update').removeClass('hidden')
    }
  })
})

/**
 * Translate
 *
 * @param {string} key
 * @param {=object} parameters
 * @return string
 */
function t (key, parameters) {
  var value = key
  if (typeof owg.translations[owg.language] !== 'undefined' && typeof owg.translations[owg.language][key] !== 'undefined') {
    value = owg.translations[owg.language][key]
  } else if (typeof owg.translations['en'][key] !== 'undefined') {
    value = owg.translations['en'][key]
  }
  if (parameters) {
    for (var i in parameters) {
      value = value.replace(new RegExp('{' + i + '}', 'ig'), parameters[i])
    }
  }
  return value
}

/**
 * Display a loading spinner in a given element
 * @param {string|jQuery} el
 */
function spinner (el) {
  el = $(el)
  el.append('<div class="spinner">' +
    '<div class="bounce1"></div>' +
    '<div class="bounce2"></div>' +
    '<div class="bounce3"></div>' +
    '</div>')
}

/**
 * Check for version update
 * @param {=function} callback
 */
function checkForUpdate (callback) {
  $.getJSON(owg.rootUrl + '/index.php/settings?check-update=1', callback)
}

function setAnnotationTime() {

  var annotations = $('.annotation')
  annotations.find('input[name="annotation-time-store"]').val(annotations.find('.annotation-time').html())
  annotations.find('input[name="annotation-comment"]').focus()
}
