//
//  Shader.fsh
//  Winterbells
//
//  Created by Keith Pitt on 20/02/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
