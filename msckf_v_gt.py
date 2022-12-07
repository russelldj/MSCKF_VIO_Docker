import argparse
import matplotlib
import numpy
import open3d
from pathlib import Path


# GT format is [time, x, y, z, qx, qy, qz, qw]
# Other output should match first 8 spots, then can have optional more columns


def make_cloud(points, colors=None):
    cloud = open3d.geometry.PointCloud()
    cloud.points = open3d.utility.Vector3dVector(points)
    if colors is not None:
        cloud.colors = open3d.utility.Vector3dVector(colors)
    return cloud


def main(gtpath, testpath):

    cmap = matplotlib.cm.get_cmap('gist_rainbow')

    gtarray = numpy.load(gtpath)
    testarray = numpy.load(testpath)

    # Get time running from 0-1 but on the same scale
    gttimes = gtarray[:, 0] - gtarray[0, 0]
    testtimes = testarray[:, 0] - testarray[0, 0]
    longer = max(gttimes[-1], testtimes[-1])
    gttimes /= longer
    testtimes /= longer

    open3d.io.write_point_cloud(
        gtpath.name.replace(".npy", ".ply"),
        make_cloud(gtarray[:, 1:4],
                   numpy.array([cmap(time)[:3] for time in gttimes])),
    )
    open3d.io.write_point_cloud(
        testpath.name.replace(".npy", ".ply"),
        make_cloud(testarray[:, 1:4],
                   numpy.array([cmap(time)[:3] for time in testtimes])),
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Set config via command line")
    parser.add_argument("-g", "--gt", type=Path, required=True, help="Path to GT numpy")
    parser.add_argument("-t", "--test", type=Path, required=True, help="Path to test numpy")

    args = parser.parse_args()
    assert args.gt.is_file()
    assert args.test.is_file()

    main(args.gt, args.test)
