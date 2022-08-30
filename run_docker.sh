mkdir bags
docker run -v $(realpath bags):/root/bags -it msckf /bin/bash
