# 베이스 이미지를 작성하고  AS 절에 단계 이름을 지정한다.
from GOLANG:1.15-ALPINE3.12 as gobuilder-stage

# 작성자와 설명을 작성한다.
MAINTAINER kevin,lee <hylee@shub.cloud>
LABEL "purpose"="Service Deployment using Multi-stage buils."

# /usr/src/goapp 경로로 이동한다.
WORKDIR /usr/src/goapp

# 현재 디렉토리의 goapp.go 파일을 이미지 내부의 현재 경로에 복사한다.
COPY goapp.go .

# Go언어 환경 변수를 지정하고 /usr/local/bin 경로에 gostart 실행파일을 생성한다.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -0 /usr/local/bin/gostart

# 두 번째 단계다. 두 번째 Dockerfile 을 작성한 것과 같다. 베이스 이미지를 작성한다.
# 마지막은 컨테이너로 실행되는 단계이므로 일반적으로 단계명을 명시하지 않는다.
FROM scratch AS runtime-stage

# 첫 번째 단계의 이름을 --from 옵션에 넣으면 해당 단계로부터 파일을 가져와서 복사한다.
COPY --from=gobuilder-stage /usr/local/bin/gostart /usr/local/bin/gostart

# 컨테이너 실행 시 파일을 실행하다.
CMD ["/usr/local/bin/gostart"]
