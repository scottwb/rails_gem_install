require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RailsGemInstaller do
  describe "#parse_required" do
    context "when there is a missing required gem" do
      it "should return an array of just that gem with no version" do
        gemspecs = subject.parse_required("no such file to load -- gdata\n")
        gemspecs.should have(1).gemspec
        gemspecs.first.should have(1).member
        gemspecs.first.should have_key(:name)
        gemspecs.first.should_not have_key(:version)
        gemspecs.first[:name].should == 'gdata'
      end
    end

    context "when there are no missing required gems" do
      it "should returns an empty array" do
        gemspecs = subject.parse_required("\n")
        gemspecs.should be_empty
      end
    end
  end

  describe "#parse_missing" do
    context "when there are missing gems that specify version numbers" do
      it "should return an array of gemspec hashes including name and version" do
        pending "This is currently known to be broken."
        gemspecs = subject.parse_missing <<EOT
Missing these required gems:
  sanitize  = 1.2.1

You're running:
  ruby 1.8.7.174 at blah blah blah
EOT
        gemspecs.should have(1).gemspec
        gemspecs.first.should have(2).members
        gemspecs.first[:name].should == 'sanitize'
        gemspecs.first[:version].should == '= 1.2.1'
      end
    end

    context "when there are missing gems that do not specify version numbers" do
      it "should return an array of gemspec hashes including just the name" do
        pending "This is currently known to be broken."
        gemspecs = subject.parse_missing <<EOT
Missing these required gems:
  sanitize

You're running:
  ruby 1.8.7.174 at blah blah blah
EOT
        gemspecs.should have(1).gemspec
        gemspecs.first.should have(1).member
        gemspecs.first[:name].should == 'sanitize'
      end
    end
  end

  describe "#parse_deps" do
    context "when there are uninstalled dependencies of a specific version" do
      it "should return an array of gemspec hashes including name and version" do
        gemspecs = subject.parse_deps <<EOT
 - [I] rmagick 
 - [I] gdata 
 - [I] responders ~> 0.4.6
 - [I] sanitize = 1.2.1
    - [ ] somemissinggem ~> 1.4.1
 - [I] panztel-actionwebservice = 2.3.5
    - [R] actionpack = 2.3.5
    - [R] activerecord = 2.3.5
 - [I] fastthread 
 - [I] jammit = 0.4.4
EOT
        gemspecs.should have(1).gemspec
        gemspecs.first.should have(2).members
        gemspecs.first[:name].should == 'somemissinggem'
        gemspecs.first[:version].should == '~> 1.4.1'        
      end
    end

    context "when there are uninstalled dependencies that do not specify a version" do
      it "should return an array of gemspec hashes including just the name" do
        pending "This is currently known to be broken."
        gemspecs = subject.parse_deps <<EOT
 - [I] rmagick 
 - [ ] gdata 
 - [I] responders ~> 0.4.6
 - [I] sanitize = 1.2.1
    - [I] nokogiri ~> 1.4.1
 - [I] panztel-actionwebservice = 2.3.5
    - [R] actionpack = 2.3.5
    - [R] activerecord = 2.3.5
 - [I] fastthread 
 - [I] jammit = 0.4.4
EOT
        gemspecs.should have(1).gemspec
        gemspecs.first.should have(1).member
        gemspecs.first[:name].should == 'gdata'
      end
    end
  end

end
