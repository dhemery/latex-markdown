require 'rake/clean'
require 'pathname'
require 'yaml'
require 'rake/ext/pathname'

TEMPLATE_DIR = Pathname(__FILE__).dirname
UTILS = TEMPLATE_DIR / 'utils'

require UTILS

BOOK_DIR = Pathname(ENV.fetch('DBP_BOOK_DIR', Pathname.pwd)).expand_path

PUBLICATION_DIR = BOOK_DIR / 'publication'
PUBLICATION_DATA_FILE = PUBLICATION_DIR / 'publication.yaml'

PUBLICATION = YAML.load_file(PUBLICATION_DATA_FILE)
SLUG = PUBLICATION['slug']

DBP_BUILD_DIR = Pathname('/var/tmp/dbp')
BOOK_BUILD_DIR = DBP_BUILD_DIR + SLUG

OUT_DIR = BOOK_DIR / 'uploads'
directory OUT_DIR

def output_file(medium)
  (OUT_DIR / SLUG).ext(medium.to_s)
end

def produce(medium:, prereqs: [], **env)
  template_dir = TEMPLATE_DIR / medium.to_s
  build_dir = BOOK_BUILD_DIR / template_dir.basename
  output_file = output_file(medium)

  file output_file => prereqs
  file output_file => files_copied(from: template_dir, to: build_dir)
  file output_file => FileList[PUBLICATION_DIR / "#{medium}/**/*"]
  file output_file => FileList[PUBLICATION_DIR / 'manuscript' / '**/*']
  file output_file => [PUBLICATION_DATA_FILE, OUT_DIR]

  task output_file do |t|
    subrake dir: build_dir, create: output_file, DBP_PUBLICATION_DIR: PUBLICATION_DIR, **env
  end

  desc "Build the #{medium} file"
  task medium => output_file

  task all: medium
end

PDF_FORMAT_TEMPLATE_DIR = TEMPLATE_DIR / 'pdf-format'
PDF_FORMAT_BUILD_DIR = BOOK_BUILD_DIR / PDF_FORMAT_TEMPLATE_DIR.basename
PDF_FORMAT_TEMPLATE_FILES = files_copied(from: PDF_FORMAT_TEMPLATE_DIR, to: PDF_FORMAT_BUILD_DIR)
PDF_FORMAT_FILE = (BOOK_BUILD_DIR / 'dbp.fmt').expand_path

file PDF_FORMAT_FILE => PDF_FORMAT_TEMPLATE_FILES do |t|
  subrake dir: PDF_FORMAT_BUILD_DIR, create: t.name
end

produce(medium: :pdf, prereqs: PDF_FORMAT_FILE, DBP_PDF_FORMAT_FILE: PDF_FORMAT_FILE )
produce(medium: :epub)

MOBI_FILE = output_file(:mobi)
file MOBI_FILE => output_file(:epub) do |t|
  sh 'kindlegen', t.source
end

task default: :all

desc 'Build all formats (default)'
task all: [:mobi]

desc 'Build the mobi file'
task mobi: MOBI_FILE

def subrake(dir:, create:, **env)
  cd(dir) { sh 'rake', '-r', UTILS.to_s, "DBP_OUTPUT_FILE=#{create}", *env.map { |k,v| "#{k}=#{v}" } }
end

CLEAN.include BOOK_BUILD_DIR
CLOBBER.include OUT_DIR
