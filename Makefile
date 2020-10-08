
all: 
	nim c -d:release --opt:size --passL:-s --app:gui TraceDelayNim.nim

clean:
	rm *.exe