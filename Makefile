PROGRAM_NAME= kvAgregated
TARGET= $(PROGRAM_NAME)
TEST_PROGRAM_NAME= test$(PROGRAM_NAME)

MAIN:=
SRC:=
TESTSRC:=
QSRC:=
UI:=

TOP= ../../

include $(TOP)/conf/make.$(OSTYPE)

PKG_CONFIG_LIBS= omniORB4 omniDynamic4 libxml++-1.0

INCLUDE:= -I. $(BOOSTINCLUDE) $(OMNIINCLUDE) \
	     -I$(TOP)/include \
	     -I$(PUTOOLS)/include -I$(PUTOOLS)/include/puTools \
	     -I $(TOP)/include/kvskel \
	     -I $(TOP)/include/kvservice\
	     `pkg-config --cflags $(PKG_CONFIG_LIBS)`

LIB:= -L$(TOP)/lib -lkvcpp2 -ldecodeutility -lkvalobs -ldb -lfileutil -ldl -ldnmithread \
	-lcorbahelper -lcorba_skel \
	-lmiutil -lmiconfparser -lmilog -L$(PUTOOLS)/lib -lpuTools \
	$(BOOSTLIB) -lboost_thread -lboost_regex \
	`pkg-config --libs $(PKG_CONFIG_LIBS)`


CXXFLAGS+= -Wall
DEFINES+=
CXXLDFLAGS+=


include make.mk
include test/make.mk


# Qt:
UI_IMPL= $(UI:.ui=.cc)
UI_HEAD= $(UI:.ui=.h)
MOC_SRC= $(QSRC:.cc=.moc.cc) $(UI_IMPL:.cc=.moc.cc)

ALL_SRC= $(UI_IMPL) $(QSRC) $(MOC_SRC) $(SRC)
OBJ=  $(ALL_SRC:.cc=.o)

# Test:
TESTOBJ= $(TESTSRC:.cc=.o)
TESTLIB= -lcppunit

ifndef PREFIX
	PREFIX=$(HOME)/apps/
endif 

all:  $(TEST_PROGRAM_NAME) test $(TARGET) 

install: $(TARGET)
	mkdir -p $(PREFIX)/bin/
	cp $(TARGET) $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/$(TARGET)


.cc.o:
	$(CXX) $(CXXFLAGS) $(DEFINES) $(INCLUDE) -o $@ -c $<

%.h:	%.ui
	cd $(dir $@); uic $(notdir $<) -o $(notdir $@)

%.cc: %.ui %.h
	cd $(dir $@); uic -impl $(notdir $*.h) $(notdir $<) -o $(notdir $@)


%.moc.cc:	%.h
	moc -o $@ $<

$(PROGRAM_NAME): $(OBJ) $(MAIN:.cc=.o)
	$(CXX) -o $@ -Wall $(CXXLINKSO) $(OBJ) $(MAIN:.cc=.o) $(LIB)

$(TEST_PROGRAM_NAME): $(OBJ) $(TESTOBJ)
	$(CXX) -o $@ -Wall $(CXXLDFLAGS) $(OBJ) $(TESTOBJ) $(LIB) $(TESTLIB)

$(LIB_NAME): $(OBJ)


test:  $(TEST_PROGRAM_NAME)
	@echo Running tests:; ./$(TEST_PROGRAM_NAME)


# Autogenerated dependencies:
%.d: %.cc $(UI_HEAD)
	@set -e; rm -f $@; \
	$(CXX) -MM -MQ $(basename $<).o $(CXXFLAGS) $(DEFINES) $(INCLUDE) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

DEPENDS_FILES= $(SRC:.cc=.d) $(MAIN:.cc=.d) $(QSRC:.cc=.d) $(UI_IMPL:.cc=.d) $(TESTSRC:.cc=.d) $(TESTMAIN:.cc=.d)

-include $(DEPENDS_FILES)

# Not allow qt tools to delete generated headers
KEEP_UI_HEADERS:        $(UI_HEAD)


pretty:
	rm -f core core.*
	find . -name '*~' -type f -exec rm -f  {} \;
	find . -name '*.d.*' -type f -exec rm -f  {} \;

clean: pretty
	rm -f $(OBJ) $(MAIN:.cc=.o) $(TESTOBJ) $(UI_HEAD) $(UI_IMPL) $(MOC_SRC) $(DEPENDS_FILES)

veryclean: clean
	rm -f $(TARGET) $(TEST_PROGRAM_NAME)

.PHONY: all pretty clean test KEEP_UI_HEADERS
