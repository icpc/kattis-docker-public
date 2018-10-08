CFLAGS=-O2 -std=gnu99 -static
CXXFLAGS=-g -O2 -static -std=gnu++14
MEMLIM=512
JAVAFLAGS=-XX:+UseSerialGC -Xss64m -Xms$(MEMLIM)m -Xmx$(MEMLIM)m -Dfile.encoding=UTF-8
LDFLAGS=-lm

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

%.out : % %.in
	./$* < $*.in > $*.out
