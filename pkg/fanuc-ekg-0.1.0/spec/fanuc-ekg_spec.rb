
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe FANUC::Ekg do
	
	#it "should be able to open a file" do
		#f = FANUC::Ekg.open(File.join(File.dirname(__FILE__), %w[fixtures R14_2010_09_24.csv]))
		#f.should be_a_kind_of(File)
	#end
	
	describe "with file" do
		before(:each) do
			#@f = FANUC::Ekg.open(File.join(File.dirname(__FILE__), %w[fixtures R14_2010_09_24.csv]))
			@f = open(File.join(File.dirname(__FILE__), %w[fixtures R14_2010_09_24.csv]))
		end
		
		it "should split into a hash" do
			@s = FANUC::Ekg.split(@f).should be_a_kind_of(Hash)
		end
		
		it "should have the right keys" do
			FANUC::Ekg.split(@f).keys.should eql([:bins,:recent,:worst])
		end
	end

	describe FANUC::Ekg::EkgData do
		it "should return an FANUC::Ekg::EkgData object" do
			FANUC::Ekg.parse(File.join(File.dirname(__FILE__), %w[fixtures R14_2010_09_24.csv])).should be_a_kind_of(FANUC::Ekg::EkgData)
		end
		before(:each) do
			@ekg_data = FANUC::Ekg.parse(File.join(File.dirname(__FILE__), %w[fixtures R14_2010_09_24.csv]))
		end
		
		it "should respond to bins" do
			@ekg_data.respond_to?(:bins).should be_true
		end
		
		it "should have 5 bins" do
			@ekg_data.bins.length.should eql(5)
		end
		
		it "should have 10 axes in each bin" do
			@ekg_data.bins.each do |key,bin|
				bin.collision_counts.length.should eql(10)
			end
		end
		
		describe "bins" do
			it "zero should have a total of 5886" do
				@ekg_data.bins[:zero].total.should eql(5886)
			end
			
			it "zero, axis 1, should have a total of 543" do
				@ekg_data.bins[:zero][1].should eql(543)
			end
			
			it "v1t1, axis 3, should have a total of 299" do
				@ekg_data.bins[:v1t1][3].should eql(299)
			end
			
		end
		
		it "should be able to total collisions for each axis" do
			@ekg_data.respond_to?(:axis).should be_true
		end
		
		it "should have the right total for axis 1, 1202" do
			@ekg_data.axis(1).should eql(1202)
		end
		
		it "should have 10 recent alarms" do
				@ekg_data.alarms[:recent].length.should eql(10)
		end
		
		it "should have 10 worst alarms" do
			@ekg_data.alarms[:worst].length.should eql(10)
		end
		
	end
end

