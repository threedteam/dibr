说明：本文件夹的代码为基于深度学习的空洞填充算法提供含有空洞的输入图像，参见论文《Spatio-temporal Hole-filling for DIBR System.doc》：

/threed_tv/trunk/hardware/DIBR/doc/paper/Spatio-temporal Hole-filling for DIBR System/对比试验/cnn_input_gen：
source code of the input generation for Hole filling algorithm based on deep learning:
main.m: the file that contains the main function
    |—threed_image_warping.m: the function to perform 3D image warping
        |—SubdivideRefImg.m: subdivide the reference image into sheets
        |—DepthLevelToZ.m: return the actual z (depth)        
        |—projUVZtoXY.m: return the scene point (X, Y) with respect to the world
        |—projXYZtoUV.m: return the image point (u, v) which is corresponding to an scene point (x, y) with respect to the world coordinate system
            |—hnormalise.m: normalises array of homogeneous coordinates to a scale of 1
    |—big_holes_dilation.m: dilate big holes in each destination image according to non-hole matrix to correct matching errors
		|-detect_holes.m: Return the number of the continuate holes in destination image and the horizontal coordinate of the terminal hole
	    |-dilated_big_holes.m:  return the horizontal coordinates of starting points and end points of current hole, and the disparity map value
            |-process_right_view.m: return the horizontal coordinates of starting points and end points of current hole
			|-process_left_view.m: return the horizontal coordinates of starting points and end points of current hole



