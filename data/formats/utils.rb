def files_copied(from:, to:)
  files_created(from_each: from / '**/*', as: "%{^#{from}/,#{to}/}p") do |dep|
    cp dep[:source], dep[:dir]
  end
end

def files_created(from_each:, as:, &block)
  FileList[from_each]
      .exclude { |f| Pathname(f).directory? }
      .map { |source| mapped_dependency(source, as) }
      .each { |dep| mapped_file_task(dep, &block) }
      .map { |dep| dep[:target] }
end

def mapped_file_task(dep)
  directory dep[:dir]
  file dep[:target] => [dep[:source], dep[:dir]] do
    yield dep
  end
end

def mapped_dependency(source, map)
  target = source.pathmap(map)
  { source: source, target: target, dir: target.pathmap('%d') }
end
