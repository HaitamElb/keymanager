



FROM openjdk:11

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

# Build-time environment variables
ARG spring_config_label
ARG active_profile
ARG spring_config_url
ARG is_glowroot
ARG artifactory_url
ARG hsm_client_zip_path

# Runtime environment variables
ENV active_profile_env=${active_profile}
ENV spring_config_label_env=${spring_config_label}
ENV spring_config_url_env=${spring_config_url}
ENV is_glowroot_env=${is_glowroot}
ENV artifactory_url_env=${artifactory_url}
ENV hsm_zip_file_path=${hsm_client_zip_path}
ENV loader_path_env=/home/mosip/additional_jars/

# Additional settings
ARG container_user=mosip
ARG container_user_group=mosip
ARG container_user_uid=1001
ARG container_user_gid=1001
ARG hsm_local_dir=hsm-client

ENV hsm_local_dir_name=${hsm_local_dir}
ENV work_dir=/home/${container_user}

# Install packages and create user
RUN apt-get -y update \
&& apt-get install -y unzip sudo dos2unix \
&& groupadd -g ${container_user_gid} ${container_user_group} \
&& useradd -u ${container_user_uid} -g ${container_user_group} -s /bin/sh -m ${container_user} \
&& adduser ${container_user} sudo \
&& echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
&& mkdir -p /usr/local/lib/softhsm /config \
&& chown -R ${container_user}:${container_user} /usr/local/lib/softhsm /config

# Set working directory for the user
WORKDIR ${work_dir}

# Copy and set up configuration script
COPY configure_start.sh configure_start.sh
RUN dos2unix configure_start.sh \
&& chmod +x configure_start.sh

# Create additional directory for JAR files
RUN mkdir -p ${loader_path_env}

# Copy JAR files to the target directory
COPY ./target/*.jar ${work_dir}/kernel-keymanager-service.jar

# Change permissions of files in working directory
RUN chown -R ${container_user}:${container_user} ${work_dir}

# Set the user for the following operations
USER ${container_user_uid}:${container_user_gid}

# Expose necessary ports
EXPOSE 8088
EXPOSE 9010

# Entry point and default command
ENTRYPOINT [ "./configure_start.sh" ]
CMD ["sh", "-c", "if [ \"$is_glowroot_env\" = \"present\" ]; then \
    wget -q --show-progress \"$artifactory_url_env/artifactory/libs-release-local/io/mosip/testing/glowroot.zip\"; \
    unzip glowroot.zip; \
    rm -rf glowroot.zip; \
    sed -i 's/<service_name>/kernel-keymanager-service/g' glowroot/glowroot.properties; \
    wget \"$artifactory_url_env/$hsm_zip_file_path\" -O \"$loader_path_env/kernel-auth-adapter.jar\"; \
    java -jar -javaagent:glowroot/glowroot.jar -Dloader.path=\"$loader_path_env\" -Dspring.cloud.config.label=\"$spring_config_label_env\" -Dspring.profiles.active=\"$active_profile_env\" -Dspring.cloud.config.uri=\"$spring_config_url_env\" -XX:HeapDumpPath=/home/ ./kernel-keymanager-service.jar; \
else \
    wget \"$artifactory_url_env/$hsm_zip_file_path\" -O \"$loader_path_env/kernel-auth-adapter.jar\"; \
    java -jar -Dloader.path=\"$loader_path_env\" -Dspring.cloud.config.label=\"$spring_config_label_env\" -Dspring.profiles.active=\"$active_profile_env\" -Dspring.cloud.config.uri=\"$spring_config_url_env\" ./kernel-keymanager-service.jar; \
fi"]
