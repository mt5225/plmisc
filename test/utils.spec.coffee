mod = require "#{process.cwd()}/src/utils"

describe 'Utils', ->
  it 'should exist', ->
    mod.should.be.ok

  describe '#utils', ->
    it 'should return the right value', ->
      mod.utils().should.eql  'Utils'