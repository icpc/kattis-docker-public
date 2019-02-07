CFLAGS=-O2 -std=gnu99 -static
CXXFLAGS=-g -O2 -static -std=gnu++14
MEMLIM=512
JAVAFLAGS=-XX:+UseSerialGC -Xss64m -Xms$(MEMLIM)m -Xmx$(MEMLIM)m -Dfile.encoding=UTF-8
LDFLAGS=-lm

GCC_VERSION=7.3.0
GXX_VERSION=7.3.0
JAVA_VERSION=1.8.0_181
KOTLIN_VERSION=1.3.0
PYTHON3_VERSION=3.6
PYTHON_VERSION=2.7
PYPY_VERSION=5.10
PYPY_SLIM_VERSION=0e7ea4fe15e8

null:
	@echo ""

% : %.c
	$(CC) -o $@ $(CFLAGS) $< $(LDFLAGS)

% : %.cpp
	$(CXX) -o $@ $(CXXFLAGS) $< $(LDFLAGS)

% : %.cc
	$(CXX) -o $@ $(CXXFLAGS) $< $(LDFLAGS)

% : %.java
	javac -encoding UTF-8 -sourcepath . -d . $<
	if ! egrep ^package $< ; then \
		echo "#!/bin/sh\njava $(JAVAFLAGS) -cp . $*" >$@ && chmod +x $@ ; \
	else \
		PKG=$$(egrep '^[ 	]*package [-a-z.0-9]+' $< | head -1 | sed -e 's/.*package[ 	]*\([a-z0-9.]*\).*/\1/') && echo "#!/bin/sh\njava $(JAVAFLAGS) -cp . $$PKG.$*" >$@ && chmod +x $@ ; \
	fi

% : %.kt
	kotlinc -d . $<
	if ! egrep ^package $< ; then \
		echo "#!/bin/sh\njava $(JAVAFLAGS) -cp '/usr/local/kotlinc/lib/*:.' $*Kt" >$@ && chmod +x $@ ; \
	else \
		PKG=$$(egrep '^[ 	]*package [-a-z.0-9]+' $< | head -1 | sed -e 's/.*package[ 	]*\([a-z0-9.]*\).*/\1/') && echo "#!/bin/sh\njava $(JAVAFLAGS) -cp '/usr/local/kotlinc/lib/*:.' $$PKG.$*Kt" >$@ && chmod +x $@ ; \
	fi

% : %.py
	cp $< $@
	chmod +x $@

%.out : % %.in
	./$* < $*.in > $*.out
