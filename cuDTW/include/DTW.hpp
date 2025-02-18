#ifndef DTW_HPP
#define DTW_HPP

namespace FullDTW {
#include "./kernels/SHFL_FULLDTW_ALL.cuh"

template <
    typename value_t,
    typename index_t> __host__
void dist (
    value_t * Subject,
    value_t * Dist,
    index_t num_entries,
    index_t num_features,
    index_t num_queries,
    cudaStream_t stream=0) {

	const dim3 grid (num_entries, 1, 1);
	const dim3 block(         32, 1, 1);
	shfl_FullDTW_ALL <<<grid, block, 0, stream>>>
	(Subject, Dist, num_entries, num_features);
	return;
}
}
#endif
