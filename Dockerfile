
# 🐳 Base image
FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime
# 🚫 Remove interactivity since using the base image will ask for a timezone - This allows to not provide it
ENV DEBIAN_FRONTEND=noninteractive
# 📚 Install missing system packages (git, libgl1, ..., are needed for Stable Diffusion and are not installed in the base image)
RUN apt-get update && \
    apt-get install -y wget git python3 python3-venv libgl1 libglib2.0-0
# 👱 Create a user and Set the working directory
RUN useradd -m user
USER user
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
ENV CLI_ARGS=""
ENV HOME=${ROOT_DIR}
ENV WEBUI_PORT=7860
EXPOSE ${WEBUI_PORT}
CMD [ "./webui.sh", "$${CLI_ARGS}" ]