# For custom matchers:
# https://github.com/sethvargo/chefspec#writing-custom-matchers
#

def add_nrpe_check(name)
  ChefSpec::Matchers::ResourceMatcher.new(:nrpe_check, :add, name)
end

