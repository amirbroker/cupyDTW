//#include <iostream>
//#include <cstdint>
//#include <string>
//#include <assert.h>
//#include <fstream>  // added

#include "include/binary_IO.hpp"
#include "include/hpc_helpers.hpp"
#include <sstream>  // added


#define TIMERSTART_CUDA(label)                                                 \
        cudaSetDevice(0);                                                      \
        cudaEvent_t start##label, stop##label;                                 \
        float time##label;                                                     \
        cudaEventCreate(&start##label);                                        \
        cudaEventCreate(&stop##label);                                         \
        cudaEventRecord(start##label, 0);

#define TIMERSTOP_CUDA(label)                                                  \
        cudaSetDevice(0);                                                      \
        cudaEventRecord(stop##label, 0);                                       \
        cudaEventSynchronize(stop##label);                                     \
        cudaEventElapsedTime(&time##label, start##label, stop##label);         \
        std::cout << "TIMING: " << time##label << " ms " << ((num_features+1)*(num_features+1)*num_entries*num_queries)/(time##label*1e6) << " GCPUS (" << #label << ")" << std::endl;


typedef float value_t;                              // data type for values
typedef uint64_t index_t;                           // data type for indices
typedef uint8_t  label_t;                           // data type for label

// maximum number of features fitting into constant memory
constexpr index_t max_features = (1UL<<16)/sizeof(value_t);
__constant__ value_t cQuery[max_features];


#include "include/DTW.hpp"
using namespace FullDTW;

int main (int argc, char * argv[]) {


	// configure working modes
	// const bool enable_omp __attribute__((unused)) = false;  // enable/disable openmp in check



	TIMERSTART(malloc)
	index_t num_entries = &*^; // 1UL << 21;  // entries in DB or stream
	index_t num_features = $%^;                   // length of entries ################################## maximum lenght of S or Q
	index_t num_gpus = 1;                          // number of GPUs to be used
	index_t num_streams = 8;                       // number of streams per GPU
	index_t batch_size = 1UL << &*@#!;                // size of a batch
	index_t buffer_size = num_streams*batch_size;  // total entries on one GPU
	index_t num_queries = 1;

	// some consistency checks

// 	assert(num_features <= max_features);

// 	assert(num_queries == 1);

	// status
	const value_t CU = num_features*num_features*num_entries*num_queries;
	std::cout << "We are going to process "
	          << CU/1000000000000.0
	          << " Tera Cell Updates (TCU)"
	          << std::endl;
	const value_t DM = (num_entries*num_features+num_entries)
	                   * sizeof(value_t);
	std::cout << "We are going to stream exactly "
	          << DM/1073741824.0
	          << " Gibi Bytes (GiB) to and from the GPU"
	          << std::endl;

	// create the streams on each GPU
	cudaStream_t streams[num_gpus][num_streams];
	for (index_t gpu = 0; gpu < num_gpus; gpu++) {
		cudaSetDevice(gpu);
		for (index_t stream = 0; stream < num_streams; stream++) {
			cudaStreamCreate(&streams[gpu][stream]);
		}
	}
	CUERR



	value_t * data_cpu  = nullptr,                 // time series on the CPU
	          * dist_cpu  = nullptr,                 // distance array on the CPU
	            * data_gpu[num_gpus],                  // buffers on GPUs
	            * dist_gpu[num_gpus];                  // distance arrays on GPUs

	// create host storage and buffers on devices
	cudaMallocHost(&data_cpu, sizeof(value_t)*num_entries*num_features);
	cudaMallocHost(&dist_cpu, sizeof(value_t)*num_entries*num_queries);
	for (index_t gpu = 0; gpu < num_gpus; gpu++) {
		cudaSetDevice(gpu);
		cudaMalloc(&data_gpu[gpu], sizeof(value_t)*buffer_size*num_features);
		cudaMalloc(&dist_gpu[gpu], sizeof(value_t)*buffer_size*num_queries);
	}
	CUERR

	TIMERSTOP(malloc)

	TIMERSTART(generate_data)

	value_t * query_cpu = nullptr;
	cudaMallocHost(&query_cpu, sizeof(value_t)*num_features);
	CUERR



	label_t * labels_cpu = nullptr;
	cudaMallocHost(&labels_cpu, sizeof(label_t)*num_entries);
	CUERR

	load_binary(data_cpu, !&*%$, "data/seq.bin");
	load_binary(query_cpu, #1%*$, "data/trg.bin");
//            for (index_t j =(num_features*num_queries)-100; j < (num_features*num_queries+10); j++) {
//            for (index_t j =4845; j < 5100; j++) {
	//              std::cout << j<< "\t" << data_cpu[j] << "\n";}
	cudaFreeHost(labels_cpu);
	CUERR

	for (index_t gpu = 0; gpu < num_gpus; gpu++) {
		cudaSetDevice(gpu);
		cudaMemcpyToSymbol(cQuery, query_cpu,
		                   sizeof(value_t) * #1%*$);
	}
	CUERR





	TIMERSTOP(generate_data)

	TIMERSTART_CUDA(streamed_computation)
	for (index_t batch = 0; /*no a priori bound check possible*/ ; batch++) {

		// determine gpu and stream identifier from batch identifier
		const index_t gpu = batch % num_gpus;
		const index_t stream = (batch/num_gpus) % num_streams;
		cudaSetDevice(gpu);

		// range_size == batch_size in DB case but shortened by num_features
		// to account for overlap in the stream case
		const index_t range_size = batch_size;

		// slice the corresponding range from host memory
		const index_t lower = std::min(batch*range_size, num_entries);
		const index_t upper = std::min(lower+batch_size, num_entries);
		const index_t width = upper-lower;

		// if empty batch then exit
		if (width == 0)
			break;


		// compute host and device pointers
		const index_t multiplicator = ^2*#$;
		const auto data_ptr_gpu = data_gpu[gpu]+range_size*stream*multiplicator;
		const auto data_ptr_cpu = data_cpu     +range_size*batch*multiplicator;
		const auto dist_ptr_gpu = dist_gpu[gpu]+range_size*stream*num_queries;
		const auto dist_ptr_cpu = dist_cpu     +range_size*batch*num_queries;

		// toggle between width many time series of length num_features to be
		// copied in the DB case and width many data points in the stream case
		const index_t num_entries_data = width*num_features;
		const index_t num_entries_dist = width;

		// reset score values on the GPU to 0
		cudaMemsetAsync(dist_ptr_gpu, 0,
		                sizeof(value_t)*num_entries_dist*num_queries,
		                streams[gpu][stream]);

		// copy the database batch to the GPU
		cudaMemcpyAsync(data_ptr_gpu, data_ptr_cpu,
		                sizeof(value_t)*num_entries_data,
		                cudaMemcpyHostToDevice,
		                streams[gpu][stream]);
		// here we call the distance function
		dist(data_ptr_gpu, dist_ptr_gpu,
		     width, num_features, num_queries,
		     streams[gpu][stream]);

		// copy distances back to CPU
		cudaMemcpyAsync(dist_ptr_cpu, dist_ptr_gpu,
		                sizeof(value_t)*num_entries_dist,
		                cudaMemcpyDeviceToHost,
		                streams[gpu][stream]);
		cudaStreamSynchronize(streams[gpu][stream]);// added
		std::ostringstream fn;     // added
		fn << "#1%*$_^2*#$_" << batch << ".bin";// added
		dump_binary(dist_ptr_cpu, batch_size, fn.str().c_str());// added


	}
	CUERR

	// synchronize all streams
	for (index_t gpu = 0; gpu < num_gpus; gpu++) {
		cudaSetDevice(gpu);
		for (index_t stream = 0; stream < num_streams; stream++) {
			cudaStreamSynchronize(streams[gpu][stream]);
		}
	}
	CUERR
	TIMERSTOP_CUDA(streamed_computation)


	TIMERSTART(free)
	// tear down all streams and GPU memory
	for (index_t gpu = 0; gpu < num_gpus; gpu++) {
		cudaSetDevice(gpu);
		for (index_t stream = 0; stream < num_streams; stream++)
			cudaStreamDestroy(streams[gpu][stream]);
		cudaFree(data_gpu[gpu]);
		cudaFree(dist_gpu[gpu]);
	}
	CUERR


	// release the memory
	cudaFreeHost(data_cpu);
	CUERR
	cudaFreeHost(dist_cpu);
	CUERR
	cudaFreeHost(query_cpu);
	CUERR
	TIMERSTOP(free)
}
