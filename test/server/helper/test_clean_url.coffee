'use strict'
CleanUrl = require '../../../lib/helper/clean_url'
should = require('should')
describe 'clean url', ()->
  it 'clean hash', (done)->
    clean_url = new CleanUrl 'http://qqaabb.com/Default.asp#reply'
    clean_url.is_web_app().should.be.false
    clean_url.clean().should.equal 'http://qqaabb.com/Default.asp'

    clean_url = new CleanUrl 'http://qqaa.com/Default.asp#reply/akdlfjaslkdfj/#ldsjsfksj'
    clean_url.is_web_app().should.be.false
    clean_url.clean().should.equal 'http://qqaa.com/Default.asp'
    done()

  it 'not cleaning web app', (done)->
    clean_url = new CleanUrl 'http://episodeget.sinaapp.com/list/an/'
    clean_url.is_web_app().should.be.false
    clean_url.clean().should.equal 'http://episodeget.sinaapp.com/list/an/'

    clean_url = new CleanUrl 'http://episodeget.sinaapp.com/#/list/an/'
    clean_url.is_web_app().should.be.true
    clean_url.clean().should.equal 'http://episodeget.sinaapp.com/#/list/an/'

    clean_url = new CleanUrl 'http://episodeget.sinaapp.com/view/#/list/an/'
    clean_url.is_web_app().should.be.true
    clean_url.clean().should.equal 'http://episodeget.sinaapp.com/view/#/list/an/'
    done()