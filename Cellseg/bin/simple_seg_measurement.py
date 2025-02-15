#!/usr/bin/env python
# edited by yang
import skimage.io as io
import skimage.measure as measure
import skimage.color as color
from skimage.segmentation import clear_border
import numpy as np
import pandas as pd
import os, glob, sys, argparse
from sklearn.neighbors import NearestNeighbors
from sklearn import preprocessing
import matplotlib.gridspec as gridspec
import math
import matplotlib.pyplot as plt
import seaborn as sns

def read_channels(paths):
    stack = []
    markers = []
    for p in paths:
        channel = io.imread(p)
        stack.append(channel)
        markername = os.path.splitext(os.path.split(p)[1])[0]
        markers.append(markername)
    stack = np.moveaxis(stack, 0, -1)
    stack = np.squeeze(stack)
    return stack, markers


## Property function definitions:
def median_intensity(regionmask, intensity):
    return np.median(intensity[regionmask], axis=0)


def std_intensity(regionmask, intensity):
    return np.std(intensity[regionmask], axis=0)


def rename_properties(df, prop, markers):
    prop_named = [f'{prop}_'+ elem for elem in markers]
    prop_numbered = [f'{prop}-{i}' for i in range(len(markers))]
    rename_dict = dict(zip(prop_numbered,prop_named))
    df = df.rename(columns=rename_dict)
    return df, prop_named


def calc_neighbours(measurements, n_neighbours=5):
    # calculate object neighbours based on cell centroid position
    coords = measurements[['centroid-x', 'centroid-y']].values
    nbrs = NearestNeighbors(n_neighbors=n_neighbours, algorithm='kd_tree').fit(coords)
    distances, indices = nbrs.kneighbors(coords)

    neighbour_labels = indices+1
    neighbour_columns=['label'] + [f'neighbour_{i}_label' for i in range(n_neighbours-1)]
    neighbour_df = pd.DataFrame(data=neighbour_labels, columns=neighbour_columns)
    distance_columns = [f'distance_neighbour_{i}' for i in range(n_neighbours-1)]
    distance_df = pd.DataFrame(data=distances[:,1:], columns=distance_columns)
    # merge result:
    nearest_neighbours = pd.merge(neighbour_df, distance_df,  left_index=True, right_index=True)
    return nearest_neighbours

def plot_channels(measurements_norm, image_shape, marker_measurements, prop, outdir='.', fname='Normalised cell marker intensity.png'):
    height, width = image_shape[0], image_shape[1]
    num =  width / height
    ncols  = 7
    nrows = math.ceil(len(marker_measurements)/ncols)
    scale = 5
    
    fig = plt.figure(constrained_layout=False, figsize=((scale * ncols * num),(scale * nrows)))
    gs = gridspec.GridSpec(nrows=nrows, ncols=ncols, figure=fig)


    for i, m in enumerate(marker_measurements):
        if i ==0:
            ax0 = fig.add_subplot(gs[i])
#             ax0.set_aspect(num)
            g = sns.scatterplot(data=measurements_norm, x='centroid-x', y='centroid-y', hue=m, size=1, ax=ax0, palette='magma')
            ax0.axis('off')
            ax0.get_legend().remove()
            ax0.set_title(m)
        else:
            ax = fig.add_subplot(gs[i], sharex=ax0, sharey=ax0)
            g = sns.scatterplot(data=measurements_norm, x='centroid-x', y='centroid-y', hue=m, size=1, ax=ax, palette='magma')
            ax.axis('off')
#             ax.set_aspect(num)
            ax.get_legend().remove()
            ax.set_title(m)

    # plt.legend(loc="lower left", mode = "expand", ncol = 3)
    handles, labels = ax.get_legend_handles_labels()
    legend = fig.legend(handles[:-1], labels[:-1], loc='upper center', ncol = 10, 
               labelspacing=2, bbox_to_anchor=(0.5, 1.075), 
                        title=f"Normalised cell marker intensity {prop}", 
                        fontsize=18, frameon=False, markerscale=5, scatterpoints=10)
    legend.get_title().set_fontsize('18') 
        
    fname = fname + f"_normalised_{prop}_of_marker_intensity.png"
    spath = os.path.join(outdir, fname)
    plt.tight_layout()
    plt.savefig(spath, bbox_inches='tight')

def plot_nuclei_positions(measurements, image_shape, outdir='.', fname='Nuclei Positions'):
    height, width = image_shape
    aspect_ratio = width / height
    ncols = 7
    nrows = 1
    scale = 5
    
    fig = plt.figure(constrained_layout=False, figsize=(scale * ncols * aspect_ratio, scale))
    gs = gridspec.GridSpec(nrows=nrows, ncols=ncols, figure=fig)

    ax = fig.add_subplot(gs[0])
    sns.scatterplot(data=measurements, x='centroid-x', y='centroid-y', size=1, ax=ax, palette='magma')
    ax.axis('off')
    ax.set_title('Nuclei Positions')

    fname = fname + f"_nuclei_position.png"
    spath = os.path.join(outdir, fname)
    plt.tight_layout()
    plt.savefig(spath, bbox_inches='tight')
 


def main(args):

    full_stack_paths = glob.glob(os.path.join(args.input_dir, '*.tiff'))

    stack, markers = read_channels(full_stack_paths)

    mask = io.imread(args.label_image_path)
    mask = clear_border(mask)
    labels = measure.label(mask)

    #symoblize each label with a different colour and plot it over the original image
    fname, ext = os.path.splitext(args.output_file)
    image_label_overlay = color.label2rgb (labels, image=mask)
    plt.imshow(image_label_overlay)
    plt.show(block=False)
    
    fname = fname + f"_nuclei_seg_color.png"
    spath = os.path.join(args.output_dir,'Segmentation_color' ,fname)
    os.makedirs(os.path.dirname(spath), exist_ok=True)
    plt.savefig(spath, bbox_inches='tight')
   # mask = mask.astype('float32')  # yang
    # Print some data about the mask
    print("Shape of mask:", mask.shape)
    plt.pause(3)
 
 #   print("Data type of mask:", mask.dtype)
 #   print("Min value in mask:", np.min(mask))
 #   print("Max value in mask:", np.max(mask))

   # Print a sample of the mask data (first 5 rows and columns)
 #   print("Sample of mask data:")
 #   print(mask[:5, :5]) 
   
    
  # Display the image (added by yang)
  #   plt.imshow(mask, cmap='gray')
  #  plt.title('mask uint8')
  #  plt.axis('off')  # Hide axes
  #  plt.show(block=False)
  #  plt.pause(3)  # Adjust the time as needed
  #   height, width = mask.shape[0], mask.shape[1]

    
   # Display the image (added by yang)
  #  plt.imshow(mask, cmap='gray')
  #  plt.title('mask_clear_border')
  #  plt.axis('off')  # Hide axes
  #  plt.show(block=False)
  #  plt.pause(3)  # Adjust the time as needed
    height, width = labels.shape[0], labels.shape[1]
    # measure properties for all regions of label image:
    properties = ['label', 
                'centroid', 
                'area', 
                'eccentricity', 
                'solidity',
                'perimeter', 
                'minor_axis_length',
                'major_axis_length',
                'mean_intensity'] 

    measurements = measure.regionprops_table(label_image=labels, 
                            intensity_image=stack, 
                            properties=properties, 
                            extra_properties=(median_intensity,std_intensity))
    measurements = pd.DataFrame(measurements)
    
    # convert row,col centroids to x, y centroids:
    measurements['Location_Center_X'] = measurements['centroid-1']
    measurements['Location_Center_Y'] = measurements['centroid-0']
    measurements['centroid-x'] = measurements['centroid-1']
    measurements['centroid-y'] =  height - measurements['centroid-0']
    
    # rename numeric columns to channel names:
    measurements, mean_properties_ids = rename_properties(measurements, 'mean_intensity', markers)
    measurements, std_properties_ids = rename_properties(measurements, 'std_intensity', markers)
    measurements, median_properties_ids = rename_properties(measurements, 'median_intensity', markers)
    
    # save measurements to csv:
    
    output_path = os.path.join(args.output_dir,'Expression',args.output_file)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    measurements.to_csv(output_path, index=False)
 
    # calculate nearest neighbours and save output:
    neighbours = calc_neighbours(measurements, n_neighbours=args.n_neighbours)
    fname, ext = os.path.splitext(args.output_file)
    nbr_fname = fname + f"_neighbours_{args.n_neighbours}" + ext
    output_path = os.path.join(args.output_dir,"Expression_neighbours", nbr_fname)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    neighbours.to_csv(output_path, index=False)

    # make a summary spatial plot of each marker channel:
    x = measurements[mean_properties_ids].values #returns a numpy array
    min_max_scaler = preprocessing.MinMaxScaler()
    x_scaled = min_max_scaler.fit_transform(x)
    measurements_norm = measurements
    measurements_norm[mean_properties_ids] = x_scaled
    fname, ext = os.path.splitext(args.output_file)
    # edit by yang
    # Call the plotting function
  
    output_path = os.path.join(args.output_dir,"Nuclei_plot" ,args.output_file)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    plot_nuclei_positions(measurements, mask.shape, outdir=os.path.dirname(output_path),fname=fname)

    #plot_channels(measurements_norm, mask.shape, mean_properties_ids, 'mean', outdir='.', fname=fname)
    ## plot channels by mean
    os.makedirs(os.path.join(args.output_dir,"Plot_channel"), exist_ok=True)
    plot_channels(measurements_norm, mask.shape, mean_properties_ids, 'mean', outdir=os.path.join(args.output_dir,"Plot_channel"), fname=fname)
   
   
    # edit by yang
    ## plot channel by deviation
    x = measurements[std_properties_ids].values #returns a numpy array
    min_max_scaler = preprocessing.MinMaxScaler()
    x_scaled = min_max_scaler.fit_transform(x)
    measurements_norm = measurements
    measurements_norm[std_properties_ids] = x_scaled
    plot_channels(measurements_norm, mask.shape, std_properties_ids, 'standard_deviation', outdir=os.path.dirname(output_path),fname=fname)
   

    print('Done.')



 
   
   


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run basic measurement of intensity properties of all multiplex channels.')
    parser.add_argument('--input_dir', type=str, help='Directory containing multiplexed images.')
    parser.add_argument('--output_dir', type=str, help='Directory to write output to.')
    parser.add_argument('--output_file', type=str, help='File to write output to.', default='Cells.csv')
    parser.add_argument('--label_image_path', type=str, help='Path to label image to use for cell segmentation.')
    parser.add_argument('--n_neighbours', type=int, help='Number of nearest neighbours to calculate.', default=5)
    args = parser.parse_args()
    main(args)
