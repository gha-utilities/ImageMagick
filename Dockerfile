FROM dpokidov/imagemagick:7.1.1-47-bullseye


COPY entrypoint.sh /


ENTRYPOINT ["bash"]
CMD ["/entrypoint.sh"]
