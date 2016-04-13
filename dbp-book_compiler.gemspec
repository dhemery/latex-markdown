# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbp/book_compiler/version'

Gem::Specification.new do |spec|
  spec.name           = 'dbp-book_compiler'
  spec.summary        = 'Driscoll Brook Press tools to compile books for publication.'
  spec.description    = <<-EOM
    Driscoll Brook Press tools to compile books for publication.

    Driscoll Brook Press uses a specialized dialect of TeX (DBPTeX) to maintain the 'canonical' text of each manuscript.

    scrivener_to_tex translates a scrivener file into DBPTeX manuscript files.

    tex_to_markdown translates files from DBPTeX to markdown.

    bb compiles epub, mobi, and pdf books from publication and manuscript files.

    Requires the following tools to be installed and accessible in the command path:
      - textutil to translate Scrivener's RTF files to simplified HTML
      - sed to translate the simplified HTML files to TeX.
      - pdftex to compile a pdf file from a set of DBPTeX files.
      - epubcheck to validate epub files
      - kindlegen to compile a mobi file from an epub file.
  EOM
  spec.platform       = Gem::Platform::RUBY
  spec.version        = DBP::BookCompiler::VERSION::STRING
  spec.authors        = ['Dale Emery']
  spec.email          = ['dale@dhemery.com']
  spec.homepage       = 'https://github.com/driscoll-brook-press/book-compiler/'
  spec.license        = 'MIT'

  spec.files          = Dir['bin/**/*', 'lib/**/*', 'data/**/*']
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ['lib']

  spec.add_runtime_dependency 'jekyll', '~> 3.1', '>= 3.1.2'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6.7'
  spec.add_runtime_dependency 'rake', '~> 11.1', '>= 11.1.1'

  spec.add_development_dependency 'minitest', '~> 5.8', '>= 5.8.4'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1', '>= 1.1.8'
end
