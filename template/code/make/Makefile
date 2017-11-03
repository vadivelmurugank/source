#*****************************************************************************
# Makefile
#
# << Description on Targets >>
#  
#
#

include make.targets
include make.rules

C_FILES=$(wildcard *.c)

$(error "message")
$(warning "message")
$(info "message")

$(error VAR is $(C_FILES))
$(warning  VAR is $(C_FILES))
$(info VAR is $(C_FILES))

.PHONY: help clean build

##################################
# Targets

help:
	@echo "Help on targets"
	@echo "Describe Targets"
	@echo "help  : Help "
	@echo "clean : Clean this"
	@echo "build : build "

clean:
	rm -rf $(BUILDDIR)/files

all: build

##################################
# Generic Target Rules

%.o: %.c
	gcc -o $@ $<

%.o: %.cpp
	g++ -o $@ $<

%.tar.gz:
	tar -cvzf  $(wildcard *.o)


##################################
# custom rules

ifneq ($(CUSTOMFILES),)
	CUSTOMFILES = $(FILESEXTN:.c++=.cpp)
endif
custombuild:
	mkdir -p $(BUILDDIR)
	build -o $@ $(CUSTOMFILES)



######## END ##################

# 
# Make Builtin Functions
#########################
#
# 
# $(subst from,to,text)		Replace from with to in text.
# $(patsubst pattern,replacement,text)			Replace words matching pattern with replacement in text.
# $(strip string)			Remove excess whitespace characters from string.
# $(findstring find,text)	Locate find in text.
# $(filter pattern...,text) Select words in text that match one of the pattern words.
# $(filter-out pattern...,text)			Select words in text that do not match any of the pattern words.
# $(sort list)			Sort the words in list lexicographically, removing duplicates.
# $(dir names...)			Extract the directory part of each file name.
# $(notdir names...)		Extract the non-directory part of each file name.
# $(suffix names...)		Extract the suffix (the last dot and following characters)			 of each file name.
# $(basename names...)	Extract the base name (name without suffix)			 of each file name.
# $(addsuffix suffix,names...)			Append suffix to each word in names.
# $(addprefix prefix,names...)			Prepend prefix to each word in names.
# $(join list1,list2)		Join two parallel lists of words.
# $(word n,text)			Extract the nth word (one-origin)			 of text.
# $(words text)			Count the number of words in text.
# $(wordlist s,e,text)	Returns the list of words in text from s to e.
# $(firstword names...)	Extract the first word of names.
# $(wildcard pattern...)	Find file names matching a shell file name pattern (not a `%' pattern)			.
# $(error text...)		When this function is evaluated, make generates a fatal error with the message text.
# $(warning text...)		When this function is evaluated, make generates a warning with the message text.
# $(shell command)		Execute a shell command and return its output.
# $(origin variable)		Return a string describing how the make variable variable was defined.
# $(foreach var,words,text) Evaluate text with var bound to each word in words, and concatenate the results.
# $(call var,param,...)	Evaluate the variable var replacing any references to $(1), $(2) with the first, second, etc. param values.
#  
# 
# Make Variables
##########################
#
# $@    The name of the target.
# $%    The target member name, when the target is an archive member.
# $<    The name of the first (or only) prerequisite.
# $?    The names of all the prerequisites that are newer than the target, with spaces between them.
# $^, $+ The names of all the prerequisites, with spaces between them. The value of $^ omits duplicate prerequisites, while $+ retains them and preserves their order.$*The stem with which an implicit rule matches.
# 
# $(@D), $(@F)	The directory part and the file-within-directory part of $@
# $(*D), $(*F)	The directory part and the file-within-directory part of $*
# $(%D), $(%F)	The directory part and the file-within-directory part of $%
# $(<D), $(<F)	The directory part and the file-within-directory part of $<
# $(^D), $(^F)	The directory part and the file-within-directory part of $^
# $(+D), $(+F)	The directory part and the file-within-directory part of $+
# $(?D), $(?F)	The directory part and the file-within-directory part of $?

