module DBP
  class << self
    def lib_dir
      Pathname(__dir__).expand_path
    end

    def root_dir
      lib_dir.dirname
    end

    def data_dir
      root_dir / 'data'
    end

    def compilers_dir
      data_dir / 'compilers'
    end

    def formats_dir
      data_dir / 'formats'
    end

    def templates_dir
      data_dir / 'templates'
    end
  end
end