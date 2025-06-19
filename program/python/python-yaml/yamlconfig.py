"""
pyyaml.py

Demonstrate the usage of python config files with yaml

"""

def CheckDictFormat(entry):
    if not isinstance(entry, dict):
        print(entry, type(entry), "Missing API group dictionary")
        return False
    return True

def ParseConfigFile(FileName):
    import yaml

    a = 0;
    with open(FileName, 'r') as ymlfile:
        cfg = yaml.load(ymlfile)

    if not bool(CheckDictFormat(cfg)): return False

    #print(cfg)
    for group in cfg.keys():
        print(" ",group)
        for apigrp in cfg[group].keys():
            print(" "*4,apigrp)
            #if not bool(CheckDictFormat(apigrp)): return False
            apilist=cfg[group][apigrp]
            for apis in apilist.keys():
                print(" "*8,apis)
                apidoc = apilist[apis]
                for name, desc in apidoc.items():
                    print(" "*12,desc)

# Main        
if (__name__ == "__main__"):
    import sys

    if len(sys.argv) < 2:
        sys.exit("Usage: %s <configfile>" %(sys.argv[0]))
    else:
        print("Executing %s %s .. \n" %(sys.argv[0], sys.argv[1]))

    # Check if file exists

    # Check the type of file

    ParseConfigFile(sys.argv[1])

class TestUM:

    def setup(self):
        print ("setup             class:TestStuff")
 
    def teardown(self):
        print ("teardown          class:TestStuff")
 
    def setup_class(cls):
        print ("setup_class       class:%s" % cls.__name__)
 
    def teardown_class(cls):
        print ("teardown_class    class:%s" % cls.__name__)
 
    def setup_method(self, method):
        print ("setup_method      method:%s" % method.__name__)
 
    def teardown_method(self, method):
        print ("teardown_method   method:%s" % method.__name__)
 
    def test_parse_file(self):

        yamlstring="""
        api: 
            "Api Names" with instrinsic underscores "__"
        param: 
            Parameters and types
         return:
            returns
        postattr:
            post compiler attribute
        preattr:
            pre compiler attributes
        include:
            include file
        lib:
            library which has this defined symbol
        file:
            implementation file
        content:
            Usage and document
        """
        print(yamlstring)
        assert (len(yamlstring) != 0)
        assert (len(yamlstring) != 0)
