/* ===========================================================================
   $Id$
 
   Project:  MapServer
   Purpose:  SWIG interface file for mapscript pointObj extensions
   Author:   Steve Lime 
             Sean Gillies, sgillies@frii.com
             
   ===========================================================================
   Copyright (c) 1996-2001 Regents of the University of Minnesota.
   
   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following conditions:
 
   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.
 
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
   ===========================================================================
*/

%extend pointObj 
{
  
    pointObj(double x=0.0, double y=0.0, double z=0.0, double m=-2e38) 
    {
        pointObj *p;
        p = (pointObj *)calloc(1,sizeof(pointObj));
        if (!p) return NULL;
        p->x = x;
        p->y = y;
	p->z = z;
        p->m = m;
        return p;
    }

    ~pointObj() 
    {
        free(self);
    }

    int project(projectionObj *projin, projectionObj *projout) 
    {
        return msProjectPoint(projin, projout, self);
    }	

    int draw(mapObj *map, layerObj *layer, imageObj *image, int classindex, 
             char *text) 
    {
        return msDrawPoint(map, layer, self, image, classindex, text);
    }

    double distanceToPoint(pointObj *point) 
    {
        return msDistancePointToPoint(self, point);
    }

    double distanceToSegment(pointObj *a, pointObj *b) 
    {
        return msDistancePointToSegment(self, a, b);
    }

    double distanceToShape(shapeObj *shape) 
    {
        return msDistancePointToShape(self, shape);
    }

    int setXY(double x, double y, double m=-2e38) 
    {
        self->x = x;
        self->y = y;
	self->z = 0.0;
        self->m = m;
	
        return MS_SUCCESS;
    }

    int setXYZ(double x, double y, double z, double m=-2e38) 
    {
        self->x = x;
        self->y = y;
	self->z = z;
        self->m = m;
        return MS_SUCCESS;
    }

    int setXYZM(double x, double y, double z, double m) 
    {
        self->x = x;
        self->y = y;
	self->z = z;
	self->m = m;
        return MS_SUCCESS;
    }

    %newobject toString;
    char *toString() 
    {
        char buffer[256];
        const char *fmt;

	if( self->m < -1e38 )
	    fmt = "{ 'x': %.16g , 'y': %.16g, 'z': %.16g }";
	else
	    fmt = "{ 'x': %.16g , 'y': %.16g, 'z': %.16g, 'm': %.16g }";
	
        msPointToFormattedString(self, fmt, (char *) &buffer, 256);
        return strdup(buffer);
    }
}

