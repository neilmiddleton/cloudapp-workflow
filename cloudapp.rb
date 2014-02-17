#!/usr/bin/env ruby
# encoding: utf-8

($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require 'bundle/bundler/setup'
require 'alfred'
require 'uri'
require 'net/http'
require 'json'

uri = URI.parse ARGV[0]
http = Net::HTTP.new(uri.host, uri.port)

res = http.get(uri, {'Accept' => 'application/json'})

data = JSON.parse(res.body)

Alfred.with_friendly_error do |alfred|
  feedback = alfred.feedback

  feedback.add_item({
    uid: '',
    title: 'Direct Link',
    subtitle: data['content_url'],
    arg: data['content_url']
    })
  feedback.add_item({
    uid: '',
    title: 'Download Link',
    subtitle: data['download_url'],
    arg: data['download_url']
    })
  feedback.add_item({
    uid: '',
    title: 'Thumbnail URL',
    subtitle: data['thumbnail_url'],
    arg: data['thumbnail_url']
    })

  if data['item_type'] == 'image'
    feedback.add_item({
      uid: '',
      title: 'Markdown',
      subtitle: "",
      arg: "[![](#{data['thumbnail_url']})](#{data['content_url']})"
      })
  end

  puts feedback.to_alfred
end