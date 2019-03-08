#!/bin/env ruby
# frozen_string_literal: true

require 'scraped'
require 'scraperwiki'
require_relative 'lib/cabinet'

Scraped::Scraper.new('Q21100241' => CabinetScraper).store(:memberships, index: %i[position_id])

positions = Cabinet.new(cabinet: 'Q2421589').positions
puts positions if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE positions') rescue nil
ScraperWiki.save_sqlite([:id], positions, 'positions')
