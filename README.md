# Classification Use-Case

### Build & Run Configs

* Import from Dockerfile
* GIT REPO URL: https://github.com/ojjsaw/ov-classification.git
* GIT Branch: main
* Dockerfile Path: Dockerfile
* Mount directories for model input, output
  * Output Mount Point: /result
  * Filesystem Path: PATH_TO_MY_MODEL_PROJECT_DIR
  * Input Mount Point: /test
  * Output Mount Point: /result
* Test videos can be downloaded from: https://storage.openvinotoolkit.org/data/test_data/videos
* Refer to the label txt files for supported labels while selecting test videos

### Supported Container Environment Variables

| Envr Var | Usage | Default Value |
| -------- | ----- | ------------- |
| MODEL    | path to .xml file from volume mount | NONE |
| INPUT    | (optional) path to custom video or images, one video provided inside container | /app/fruit-and-vegetable-detection.mp4 |
| DEVICE   | (optional) supports CPU or GPU or AUTO | CPU  |
| OUTPUT   | path to output file on volume mount | /result/output.mp4  |
| LABELS   | (optional) labels file path | /app/imagenet_2012.txt  |



Example:
``` 
-e MODEL=/test/mypath/to/mymodel.xml -e OUTPUT=/result/output.mp4
```


### Supported Models from OMZ

* alexnet
* caffenet
* convnext-tiny
* densenet-121
* densenet-121-tf
* dla-34
* efficientnet-b0
* efficientnet-b0-pytorch
* efficientnet-v2-b0
* efficientnet-v2-s
* googlenet-v1
* googlenet-v1-tf
* googlenet-v2-tf
* googlenet-v3
* googlenet-v3-pytorch
* googlenet-v4-tf
* hbonet-0.25
* hbonet-1.0
* inception-resnet-v2-tf
* levit-128s
* mixnet-l
* mobilenet-v1-0.25-128
* mobilenet-v1-1.0-224
* mobilenet-v1-1.0-224-tf
* mobilenet-v2
* mobilenet-v2-1.0-224
* mobilenet-v2-1.4-224
* mobilenet-v2-pytorch
* mobilenet-v3-large-1.0-224-tf
* mobilenet-v3-small-1.0-224-tf
* mobilenet-v3-large-1.0-224-paddle
* mobilenet-v3-small-1.0-224-paddle
* nfnet-f0
* octave-resnet-26-0.25
* regnetx-3.2gf
* repvgg-a0
* repvgg-b1
* repvgg-b3
* resnest-50-pytorch
* resnet-18-pytorch
* resnet-34-pytorch
* resnet-50-pytorch
* resnet-50-tf
* resnet18-xnor-binary-onnx-0001
* resnet50-binary-0001
* rexnet-v1-x1.0
* se-resnet-50
* shufflenet-v2-x0.5
* shufflenet-v2-x1.0
* squeezenet1.0
* squeezenet1.1
* swin-tiny-patch4-window7-224
* t2t-vit-14
* vgg16
* vgg19


**Note:** 

Default labels file works for above list but for below OMZ models use:
```
-e LABELS=/app/imagenet_2015.txt
```

* googlenet-v2
* se-inception
* se-resnet-50
* se-resnext-50