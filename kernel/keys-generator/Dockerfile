# Start from the base OpenJDK 11 image
FROM openjdk:11

# Update packages and install unzip tool
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install unzip dos2unix

# Arguments for build-time variables
ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME

# Labels for metadata
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

# Arguments for runtime environment variables
ARG spring_config_label
ARG active_profile
ARG spring_config_url
ARG artifactory_url
ARG spring_config_name
ARG hsm_client_zip_path
ARG hsm_local_dir=hsm-client

# Set environment variables for runtime
ENV hsm_local_dir_name=${hsm_local_dir}
ENV active_profile_env=${active_profile}
ENV spring_config_label_env=${spring_config_label}
ENV spring_config_url_env=${spring_config_url}
ENV spring_config_name_env=${spring_config_name}
ENV artifactory_url_env=${artifactory_url}
ENV hsm_zip_file_path=${hsm_client_zip_path}

# Creating folder to copy additional supporting jar files required at run-time.
ENV work_dir=/
ARG loader_path=${work_dir}/additional_jars/
RUN mkdir -p ${loader_path}
ENV loader_path_env=${loader_path}

# Copy and make executable the configure_start.sh script
COPY ./configure_start.sh ./configure_start.sh
RUN dos2unix /configure_start.sh && chmod +x /configure_start.sh

# Copy the JAR file built from your project
COPY ./target/keys-generator-*.jar ./keys-generator.jar

# Set the entrypoint and default command
ENTRYPOINT [ "./configure_start.sh" ]
CMD ["java", "-jar", "-Dloader.path=${loader_path_env}", "-Dspring.cloud.config.label=${spring_config_label_env}", "-Dspring.cloud.config.name=${spring_config_name_env}", "-Dspring.profiles.active=${active_profile_env}", "-Dspring.cloud.config.uri=${spring_config_url_env}", "/keys-generator.jar"]
