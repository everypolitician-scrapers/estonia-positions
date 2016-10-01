#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'everypolitician'
require 'scraperwiki'
require 'wikisnakker'

require 'pry'

house = EveryPolitician::Index.new.country('Estonia').legislature('Riigikogu')
wanted = house.popolo.persons.map(&:wikidata).compact

QUALIFIERS = {
  P102: :party,
  P155: :follows,
  P156: :followed_by,
  P580: :start_date,
  P582: :end_date,
  P642: :of,
  P768: :constituency,
  P1365: :replaces,
  P1366: :replaced_by,
  P2937: :term,
}.freeze

data = Wikisnakker::Item.find(wanted).map do |result|
  next if (p39s = result.P39s).empty?
  p39s.map do |posn|
    quals = posn.qualifiers
    qdata = quals.properties.partition { |p| QUALIFIERS[p] }
    qgood = qdata.first.map { |p| [ QUALIFIERS[p], quals[p].value.to_s ] }.to_h
    warn "#{result.id}: #{posn.value.id} + unknown #{qdata.last.join(", ")}" unless qdata.last.empty?

    {
      id:          result.id,
      position:    posn.value.id,
      label:       posn.value.to_s,
      description: posn.value.description(:en).to_s,
    }.merge(qgood) rescue {}
  end
end




