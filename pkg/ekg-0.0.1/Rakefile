
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'ekg'
  authors  'Jay Strybis'
  email    'jay.strybis@gmail.com'
  url      'http://github.com/unreal/ekg'
}

