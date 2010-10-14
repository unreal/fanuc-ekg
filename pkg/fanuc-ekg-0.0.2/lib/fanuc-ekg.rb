module FANUC
module Ekg

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    @version ||= File.read(path('version.txt')).strip
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args, &block )
    rv =  args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    if block
      begin
        $LOAD_PATH.unshift LIBPATH
        rv = block.call
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args, &block )
    rv = args.empty? ? PATH : ::File.join(PATH, args.flatten)
    if block
      begin
        $LOAD_PATH.unshift PATH
        rv = block.call
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end
	
	# what parser should we use
	if RUBY_VERSION.to_f >= 1.9
		require 'csv'
		PARSER = CSV
	else
		require 'faster_csv'
		PARSER = FasterCSV
	end
	
	class Bin
		attr_accessor :collision_counts
		def initialize
			@collision_counts = []
		end
		
		def total
			@collision_counts.inject {|sum,x| sum+x}
		end
		
		def [](id)
			@collision_counts[id-1]
		end
	end
		
	class Alarm
		attr_reader :occured_at, :error_text, :safety_io, :velocity, :torque, :angle, :disturbance_torque
		def initialize(options={})
			@occured_at = options["DateTime"]
			@error_text = options["ErrorText"]
			@safety_io = options["Safety I/O"]
			
			@velocity = {
				:j1 => options["Vel J1[%]"],
				:j2 => options["Vel J2[%]"],
				:j3 => options["Vel J3[%]"],
				:j4 => options["Vel J4[%]"],
				:j5 => options["Vel J5[%]"]
			}
			
			@torque = {
				:j1 => options["Torq J1[%]"],
				:j2 => options["Torq J2[%]"],
				:j3 => options["Torq J3[%]"],
				:j4 => options["Torq J4[%]"],
				:j5 => options["Torq J5[%]"]
			}
			
			@angle = {
				:j1 => options["Angle J1[rad]"],
				:j2 => options["Angle J2[rad]"],
				:j3 => options["Angle J3[rad]"],
				:j4 => options["Angle J4[rad]"],
				:j5 => options["Angle J5[rad]"],
			}
			
			@disturbance_torque = {
				:j1 => options["DistTorq J1[%]"],
				:j2 => options["DistTorq J2[%]"],
				:j3 => options["DistTorq J3[%]"],
				:j4 => options["DistTorq J4[%]"],
				:j5 => options["DistTorq J5[%]"]
			}	
		end
		
	end
	
	class EkgData
		attr_accessor :bins, :alarms
		def initialize
			@bins = {
				:zero => Bin.new,
				:v1t1 => Bin.new,
				:v2t1 => Bin.new,
				:v1t2 => Bin.new,
				:v2t2 => Bin.new
			}
			@alarms = {
				:recent => [],
				:worst => []
			}
		end
		
		def axis(id)
		@sum = 0
		@bins.each do |key,bin|
			@sum += bin[id]
		end
		# should i remove bin 0?
		@sum
	end
	end
	
	
	
	class << self
		def open(file_path)
				File.open(file_path)
		end
			
		def split(file)
			@output = {}
			@str = ""
			file.each do |line|
				next if line == "Severity\n"
				next if line == "Group,Bin0,BinV1T1,BinV2T1,BinV1T2,BinV2T2\n"
				next if line == "MRA_Num,DateTime,ErrorText,Safety I/O,Vel J1[%],Vel J2[%],Vel J3[%],Vel J4[%],Vel J5[%],Vel J6[%],Vel J7[%],Vel J8[%],Torq J1[%],Torq J2[%],Torq J3[%],Torq J4[%],Torq J5[%],Torq J6[%],Torq J7[%],Torq J8[%],Angle J1[rad],Angle J2[rad],Angle J3[rad],Angle J4[rad],Angle J5[rad],Angle J6[rad],Angle J7[rad],Angle J8[rad],DistTorq J1[%],DistTorq J2[%],DistTorq J3[%],DistTorq J4[%],DistTorq J5[%],DistTorq J6[%],DistTorq J7[%],DistTorq J8[%]\n"
				next if line == "Num,DateTime,ErrorText,Safety I/O,Vel J1[%],Vel J2[%],Vel J3[%],Vel J4[%],Vel J5[%],Vel J6[%],Vel J7[%],Vel J8[%],Torq J1[%],Torq J2[%],Torq J3[%],Torq J4[%],Torq J5[%],Torq J6[%],Torq J7[%],Torq J8[%],Angle J1[rad],Angle J2[rad],Angle J3[rad],Angle J4[rad],Angle J5[rad],Angle J6[rad],Angle J7[rad],Angle J8[rad],DistTorq J1[%],DistTorq J2[%],DistTorq J3[%],DistTorq J4[%],DistTorq J5[%],DistTorq J6[%],DistTorq J7[%],DistTorq J8[%]\n"
				if line == "Most Recent Alarms(MRA) for Group 1\n"
					@output[:bins] = @str
					@str = ""
					next
				end
				if line == "Worst Disturbance Alarms for Group 1\n"
					@output[:recent] = @str
					@str = ""
					next
				end
				@str += line
			end
			@output[:worst] = @str
			return @output
		end
		
		
		def parse(file_path)
			@ekg_data = FANUC::Ekg::EkgData.new
			
			f = open(file_path)
			output = split(f) # split the output into 3 usable CSV sections
			
			# parse bins
			PARSER.parse(output[:bins],:headers=>"Group,Bin0,BinV1T1,BinV2T1,BinV1T2,BinV2T2") do |line|
				@ekg_data.bins[:zero].collision_counts << line['Bin0'].to_i
				@ekg_data.bins[:v1t1].collision_counts << line['BinV1T1'].to_i
				@ekg_data.bins[:v2t1].collision_counts << line['BinV2T1'].to_i
				@ekg_data.bins[:v1t2].collision_counts << line['BinV1T2'].to_i
				@ekg_data.bins[:v2t2].collision_counts << line['BinV2T2'].to_i
			end
			
			# parse recent alarms
			PARSER.parse(output[:recent],:headers => "MRA_Num,DateTime,ErrorText,Safety I/O,Vel J1[%],Vel J2[%],Vel J3[%],Vel J4[%],Vel J5[%],Vel J6[%],Vel J7[%],Vel J8[%],Torq J1[%],Torq J2[%],Torq J3[%],Torq J4[%],Torq J5[%],Torq J6[%],Torq J7[%],Torq J8[%],Angle J1[rad],Angle J2[rad],Angle J3[rad],Angle J4[rad],Angle J5[rad],Angle J6[rad],Angle J7[rad],Angle J8[rad],DistTorq J1[%],DistTorq J2[%],DistTorq J3[%],DistTorq J4[%],DistTorq J5[%],DistTorq J6[%],DistTorq J7[%],DistTorq J8[%]") do |line|
				@ekg_data.alarms[:recent] << Ekg::Alarm.new(line.to_hash)
			end
			
			# parse worst disturbances
			PARSER.parse(output[:worst],:headers=>"Num,DateTime,ErrorText,Safety I/O,Vel J1[%],Vel J2[%],Vel J3[%],Vel J4[%],Vel J5[%],Vel J6[%],Vel J7[%],Vel J8[%],Torq J1[%],Torq J2[%],Torq J3[%],Torq J4[%],Torq J5[%],Torq J6[%],Torq J7[%],Torq J8[%],Angle J1[rad],Angle J2[rad],Angle J3[rad],Angle J4[rad],Angle J5[rad],Angle J6[rad],Angle J7[rad],Angle J8[rad],DistTorq J1[%],DistTorq J2[%],DistTorq J3[%],DistTorq J4[%],DistTorq J5[%],DistTorq J6[%],DistTorq J7[%],DistTorq J8[%]") do |line|
					@ekg_data.alarms[:worst] << Ekg::Alarm.new(line.to_hash)
			end
			
			@ekg_data
		end
	end

end  # module Ekg
end # module FANUC
FANUC::Ekg.require_all_libs_relative_to(__FILE__)

