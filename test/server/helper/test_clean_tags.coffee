'use strict'
CleanTags = require '../../../lib/helper/clean_tags'
should = require('should')
describe 'clean tags', ()->
  it 'one tag', (done)->
    one_tag = new CleanTags('星祈娘')
    one_tag.clean().should.eql(['星祈娘'])
    done()

  it 'two tags', (done)->
    one_tag = new CleanTags('星祈娘, 星')
    one_tag.clean().should.eql(['星祈娘', '星'])
    done()

  it '10 tags', (done)->
    one_tag = new CleanTags('星祈娘, 星, 1, 2, 3, 4, 5, 6, 7, 8')
    one_tag.clean().should.eql(['星祈娘', '星', 1, 2, 3])
    done()
