#!/usr/bin/env bash

set -e

action="${1}"

main(){

  for bin in docker nc psql;do which $bin &>/dev/null || (echo $bin not found; exit); done

  local DOCKER="postgres"
  local VERSION="10.6"
  local PGHOST="${PGHOST:-0.0.0.0}"
  local PGPORT="${PGPORT:-5432}"
  local PGDATABASE="${PGDATABASE:-postgres}"
  local PGUSER="${PGUSER:-admin}"
  local PGPASSWORD="${PGPASSWORD:-admin123456}"

  case "$action" in

    create-db)
      if [ "$(docker inspect -f '{{.State.Running}}' "$DOCKER" 2>/dev/null)" != 'true' ];
      then
        docker pull ${DOCKER}:${VERSION}
        docker volume create "${DOCKER}"-data
        docker run -it -d \
            --label "$DOCKER" \
            --name "$DOCKER" \
            --rm \
            -e LANG=en_US.UTF-8 \
            -e POSTGRES_PASSWORD="${PGPASSWORD}" \
            -e POSTGRES_USER="${PGUSER}" \
            -p "${PGPORT}":5432 \
            -v "${DOCKER}"-data:/var/lib/postgresql/data \
          ${DOCKER}:${VERSION}

        while ! docker inspect --format='{{.State.Running}}' $DOCKER; do sleep 1; done
        while ! nc -z "${PGHOST}" "${PGPORT}"; do sleep 1; done
        sleep 1

        echo "db ready ..."
        echo "PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql"
      fi
      ;;

    clean-db)
      echo "Cleaning up ..."
      docker stop ${DOCKER} 2>/dev/null
      docker volume rm "${DOCKER}"-data 2>/dev/null
      ;;

    pg_settings)
      echo "SELECT name, setting, boot_val, reset_val, unit FROM pg_settings ORDER by name;" \
          | PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql -v ON_ERROR_STOP=1 -tAe;
        ;;

    pg_shell)
      PGPORT=${PGPORT} PGHOST=${PGHOST} PGDATABASE=${PGDATABASE} PGUSER=${PGUSER} PGPASSWORD=${PGPASSWORD} psql
      ;;

    docker_shell)
      if [ "$(docker inspect --format='{{.State.Running}}' $DOCKER)" ];then
        docker exec -it ${DOCKER} bash
      fi
      ;;
    *)
      echo "Usage $(basename $0): <create-db|pg_settings|pg_shell|docker_shell|clean-db>"
      ;;

  esac

}

main "$@"
