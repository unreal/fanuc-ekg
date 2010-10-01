ekg
    by Jay Strybis
    http://strybis.com

== DESCRIPTION:

ekg
	ekg is a library for turning the data exported from the FANUC Robotics
	MotionPRO Robot EKG analysis tool.

== FEATURES/PROBLEMS:

* None yet

== SYNOPSIS:

  @ekg_data = Ekg::parse("path_to_some_ekg_file.csv")
  @ekg_data.bins[:v2t1]       # array of collisions by axis in BinV2T1
  @ekg_data.bins[:v1t1][3]    # number of collisions in BinV1T1 for axis 3
	@ekg_data.alarms[:recent]   # array of recent alarm data
  @ekg_data.alarms[:worst]    # array of worst alarm data

== REQUIREMENTS:

* A CSV file exported from DiagnosticsPRO

== INSTALL:

* sudo gem install ekg

== LICENSE:

(The MIT License)

Copyright (c) 2010 Jay Strybis

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
