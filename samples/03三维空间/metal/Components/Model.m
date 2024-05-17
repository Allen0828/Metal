//
//  Model.m
//  metal
//
//  Created by Allen on 2024/5/16.
//

#import "Model.h"
#import <MetalKit/MTKModel.h>
#import "Renderer.h"

@interface Model ()

@property (nonatomic,strong) MTKMesh *mesh;

@end

@implementation Model

- (instancetype)initWithModelName:(NSString*)name {
    if (self=[super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSURL *URL = [NSURL fileURLWithPath:filePath];
        if (URL == nil) {
            NSLog(@"model url is not found");
        }
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:Renderer.device];

        MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
        vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        
        vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
        vertexDescriptor.attributes[1].offset = 12;
        vertexDescriptor.attributes[1].bufferIndex = 0;

        vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
        vertexDescriptor.attributes[2].offset = 24;
        vertexDescriptor.attributes[2].bufferIndex = 0;
        
        vertexDescriptor.layouts[0].stride = sizeof(float)*8;
        
        MDLVertexDescriptor *layout = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
        layout.attributes[0].name = MDLVertexAttributePosition;
        layout.attributes[1].name = MDLVertexAttributeNormal;
        layout.attributes[2].name = MDLVertexAttributeTextureCoordinate;

        MDLAsset *asset = [[MDLAsset alloc] initWithURL:URL vertexDescriptor:layout bufferAllocator:allocator];
        MDLMesh *mdlMesh = (MDLMesh*)[asset objectAtIndex:0];
        
        self.mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:Renderer.device error:&error];
        if (error != nil) {
            NSLog(@"model error");
        }
    }
    return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setVertexBuffer:self.mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:0];
    }
}

@end
