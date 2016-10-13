# Run sonar analysis from maven plugin
mvn-sonar() {
	mvn sonar:sonar -Dsonar.host.url="$SONAR_URL" -Dsonar.login="$SONAR_TOKEN"
}

# Execute a full mvn build with better execution performance (single module)
mvn-single() {
	export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -DdependencyLocationsEnabled=false"
	if [ ! -z "$1" ]; then
	     mvn install verify -T 2C -am
	else
	     mvn install verify -T 2C -am "$1"
	fi
}

# Execute a full mvn build with better execution performance (multi-module)
mvn-multi() {
	export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -DdependencyLocationsEnabled=false"
    if [ ! -z "$1" ]; then
         mvn clean install -T 2C
    else
         mvn clean install -T 2C "$1"
    fi
}

# undo tar extraction
undo-tar() {
	tar tf "$1" | xargs -d'\n' rm -v 2> /dev/null
}

# check RPM content
checkrpm() {
	rpm -q -filesbypkg -p "$1"
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
