
# 🐳 Base image
FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime
# 🚫 Remove interactivity since using the base image will ask for a timezone - This allows to not provide it
ENV DEBIAN_FRONTEND=noninteractive
# 📚 Install missing system packages (git, libgl1, ..., are needed for Stable Diffusion and are not installed in the base image)
RUN apt-get update && \
    apt-get install -y wget git python3 python3-venv libgl1 libglib2.0-0
# 👱 Create a user 
RUN useradd -m user
USER user
# 📁Set working directory
ENV ROOT_DIR=/stable-diffusion-webui
WORKDIR ${ROOT_DIR}
# 📥 Download the AUTOMATIC1111 from the specified release
RUN git clone -b ${SD_WEBUI_VERSION:-v1.9.4} https://github.com/AUTOMATIC1111/stable-diffusion-webui.git ${ROOT_DIR} --single-branch
# 🔑 Give correct access rights to the user
RUN chown -R user:user ${ROOT_DIR}
# 👮‍♀️ Make the webui.sh script executable
RUN chmod +x webui.sh
# ⌛️ Install the webui.sh file (--exit parameter allows to only install it without without running it)
RUN ./webui.sh -f --exit
# ✍ Command Line Arguments
ENV CLI_ARGS=""
# 👀 Expose Port 
ENV WEBUI_PORT=7860
EXPOSE ${WEBUI_PORT}
# 🤖 Execute start script with arguments
ENTRYPOINT ["/bin/bash", "-c", "./webui.sh ${WEBUI_PORT} $CLI_ARGS"]