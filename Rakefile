
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'



Bones {
  name  'fanuc-ekg'
  authors  'Jay Strybis'
  email    'jay.strybis@gmail.com'
  url      'http://github.com/unreal/fanuc-ekg'
  depend_on 'fastercsv', '1.5.3' if RUBY_VERSION.to_f < 1.9
}

