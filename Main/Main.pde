import intel.pcsdk.*;

short[] depthMap;
int[] depth_size = new int[2];
int[] rgb_size = new int[2];
  
PImage rgbImage, depthImage;
PXCUPipeline session;
void setup()
{
  size(640, 240);
  ellipseMode(CENTER);
  session = new PXCUPipeline(this);
  if (!session.Init(PXCUPipeline.COLOR_VGA|PXCUPipeline.DEPTH_QVGA|PXCUPipeline.GESTURE))
    exit();

  if(session.QueryRGBSize(rgb_size))
    rgbImage=createImage(rgb_size[0], rgb_size[1], RGB);

  if(session.QueryDepthMapSize(depth_size))
  {
    depthMap = new short[depth_size[0] * depth_size[1]];
    depthImage=createImage(depth_size[0], depth_size[1], ALPHA);
  }
}

PXCMGesture.GeoNode node = new PXCMGesture.GeoNode();


void draw()
{ 
  background(0);

  if (session.AcquireFrame(false))
  {
    session.QueryRGB(rgbImage);
    session.QueryDepthMap(depthMap);
    for (int i = 0; i < depth_size[0]*depth_size[1]; i++)
    {
      depthImage.pixels[i] = color(map(depthMap[i], 0, 2000, 0, 255));
    }
    depthImage.updatePixels();


    if(session.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY|PXCMGesture.GeoNode.LABEL_FINGER_INDEX, node))
    {
      ParseNode(node) ;
    }

    session.ReleaseFrame();
  }
  
  image(depthImage, 0, 0, 320, 240);
  fill(255,0,0) ;
  ellipse(indexf_x,indexf_y,10,10) ;  
  image(rgbImage, 320, 0, 320, 240);
  fill(255,0,0) ;
  ellipse(indexf_x+320,indexf_y,10,10) ;

}

float indexf_x = 0 ;
float indexf_y = 0 ;
void ParseNode(PXCMGesture.GeoNode node)
{
  PXCMPoint3DF32 pos = node.positionImage;
  println("X=" + pos.x + " ,Y=" + pos.y ) ;
  indexf_x = pos.x ;
  indexf_y = pos.y ;
}

void exit()
{
  session.Close(); 
  super.exit();
}
