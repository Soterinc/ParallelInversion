import run_pose_refinement

# Input data
snapshot_path = "/app/data/nerf/nerf_synthetic/lego/model_L2.msgpack"
target_filename = "/app/data/nerf/nerf_synthetic/lego/test/r_0.png"
scene = "lego"

# Input arguments
parser = run_pose_refinement.config_parser()
args = parser.parse_args()
args.target_filename = target_filename
args.load_snapshot = snapshot_path
args.scene = scene
args.POSE_ESTIMATION_ONLY = True

error_rotation, error_translation, meta_optimization = run_pose_refinement.main(args)
