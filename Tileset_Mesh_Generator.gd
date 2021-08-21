tool
extends Spatial
#Simple Tool script for quickly generating trimeshes for Gridmap Tiles
#Attach to root node of Tile scene 
#Enable Generate Trimeshs in properties window
#Created by Chevifier

export(bool) var generate_trimeshes = false setget generate_trimesh_collisions

var created_trimeshes =0
var skipped_meshes =0 
var non_mesh_objects = 0
func generate_trimesh_collisions(generate_trimeshes):
	var meshes = get_children()
	for mesh in meshes:
		if mesh.has_method("create_trimesh_collision"):
			if mesh.get_child_count() == 0:
				mesh.create_trimesh_collision()
				print(mesh.name + ": trimesh created")
				created_trimeshes += 1
			else:
				print(mesh.name + ": trimesh exists. Skipping...")
				skipped_meshes += 1
		else:
			print(mesh.name + ": Not Mesh Instance, Skipping...")
			non_mesh_objects += 1
	generate_trimeshes = false
	
	print("==============================================")
	print("Created Trimeshes: "+ str(created_trimeshes))
	print("Skipped Meshes: "+ str(skipped_meshes))
	print("Non Mesh Objects: "+ str(non_mesh_objects))
	print("Total Objects: " + str(meshes.size()))
	created_trimeshes = 0
	skipped_meshes = 0
	non_mesh_objects = 0
