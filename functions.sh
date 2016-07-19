# run command multiple times
# example: run 10 ls -l /tmp
run() {
    seq "$1" | xargs -I "$@"
}

# remove all images from docker
dockerrmallimages() {
	docker rmi "$(docker images -q)"
}

# remove all containers from docker
dockerrmallcontainers(){
	docker rm -f "$(docker ps -a -q)"
}

# remove all dangling images and exited containers from docker
# from https://github.com/jfrazelle/dotfiles/blob/master/.dockerfunc
dockerclean(){
	docker rm -v "$(docker ps --filter status=exited -q 2>/dev/null)" 2>/dev/null
	docker rmi "$(docker images --filter dangling=true -q 2>/dev/null)" 2>/dev/null
}

# remove all stopped images from docker
dockercleanstopped(){
	local name=$1
	local state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)
	if [[ "$state" == "false" ]]; then
		docker rm "$name"
	fi
}

# list all installed applications in Linux Mint (not packages)
appsinstalled() {
	for app in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 
	do 
		app="${app##/*/}"
		echo "${app::-8}" 
	done
}

# check RPM content
checkrpm() {
	rpm -q -filesbypkg -p "$1"
}

# Execute a full mvn build with better execution performance
mvn-full-build() {
	export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -DdependencyLocationsEnabled=false"
	mvn install verify -T 2C -am "$1"
}

# Run sonar analysis from maven plugin
mvn-sonar() {
	if ! ((${#SONAR_URL[@]}))
	then
		echo "SONAR_URL must be set"
	elif ! ((${#SONAR_TOKEN[@]}))
	then
		echo "SONAR_TOKEN must be set"
	else
		mvn sonar:sonar -Dsonar.host.url="$SONAR_URL" -Dsonar.login="$SONAR_TOKEN"
	fi
}

# undo tar extraction
undo-tar() {
	tar tf "$1" | xargs -d'\n' rm -v 2> /dev/null
}

# run go cover with a temp file
# http://stackoverflow.com/questions/10516662/how-to-measure-code-coverage-in-golang
go-cover() { 
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}
