#ifndef SHFL_FULLDTW_607
#define SHFL_FULLDTW_607

template <
    typename index_t,
    typename value_t> __global__
void shfl_FullDTW_ALL (
    value_t * Subject,
    value_t * Dist,
    index_t num_entries,
    index_t num_features) {

	const index_t blid = blockIdx.x;
	const index_t thid = threadIdx.x;
	//const index_t lane = num_features+1;
	const index_t base = blid*600;
	const index_t WARP_SIZE = 32;
	const index_t l = thid;

	value_t penalty_left = INFINITY;
	value_t penalty_diag = 0;
	value_t penalty_here0 = INFINITY;
	value_t penalty_here1 = INFINITY;
	value_t penalty_here2 = INFINITY;
	value_t penalty_here3 = INFINITY;
	value_t penalty_here4 = INFINITY;
	value_t penalty_here5 = INFINITY;
	value_t penalty_here6 = INFINITY;
	value_t penalty_here7 = INFINITY;
	value_t penalty_here8 = INFINITY;
	value_t penalty_here9 = INFINITY;
	value_t penalty_here10 = INFINITY;
	value_t penalty_here11 = INFINITY;
	value_t penalty_here12 = INFINITY;
	value_t penalty_here13 = INFINITY;
	value_t penalty_here14 = INFINITY;
	value_t penalty_here15 = INFINITY;
	value_t penalty_here16 = INFINITY;
	value_t penalty_here17 = INFINITY;
	value_t penalty_here18 = INFINITY;
	value_t penalty_temp0;
	value_t penalty_temp1;

	if (thid == 0) {
		penalty_left = INFINITY;
		penalty_diag = INFINITY;
		penalty_here0 = INFINITY;
		penalty_here1 = INFINITY;
		penalty_here2 = INFINITY;
		penalty_here3 = INFINITY;
		penalty_here4 = INFINITY;
		penalty_here5 = INFINITY;
		penalty_here6 = INFINITY;
		penalty_here7 = INFINITY;
		penalty_here8 = INFINITY;
		penalty_here9 = INFINITY;
		penalty_here10 = INFINITY;
		penalty_here11 = INFINITY;
		penalty_here12 = INFINITY;
		penalty_here13 = INFINITY;
		penalty_here14 = INFINITY;
		penalty_here15 = INFINITY;
		penalty_here16 = INFINITY;
		penalty_here17 = INFINITY;
		penalty_here18 = INFINITY;
	}

	const value_t subject_value0 = l == 0 ? 0 : Subject[base+19*l-1];
	const value_t subject_value1 = Subject[base+19*l-0];
	const value_t subject_value2 = Subject[base+19*l+1];
	const value_t subject_value3 = Subject[base+19*l+2];
	const value_t subject_value4 = Subject[base+19*l+3];
	const value_t subject_value5 = Subject[base+19*l+4];
	const value_t subject_value6 = Subject[base+19*l+5];
	const value_t subject_value7 = Subject[base+19*l+6];
	const value_t subject_value8 = Subject[base+19*l+7];
	const value_t subject_value9 = Subject[base+19*l+8];
	const value_t subject_value10 = Subject[base+19*l+9];
	const value_t subject_value11 = Subject[base+19*l+10];
	const value_t subject_value12 = Subject[base+19*l+11];
	const value_t subject_value13 = Subject[base+19*l+12];
	const value_t subject_value14 = Subject[base+19*l+13];
	const value_t subject_value15 = Subject[base+19*l+14];
	const value_t subject_value16 = Subject[base+19*l+15];
	const value_t subject_value17 = Subject[base+19*l+16];
	const value_t subject_value18 = Subject[base+19*l+17];

	index_t counter = 1;
	value_t query_value = INFINITY;
	value_t new_query_value = cQuery[thid];
	if (thid == 0) query_value = new_query_value;
	if (thid == 0) penalty_here1 = 0;
	new_query_value = __shfl_down_sync(0xFFFFFFFF, new_query_value, 1, 32);



	penalty_temp0 = penalty_here0;
	penalty_here0 = (query_value-subject_value0)*(query_value-subject_value0) + min(penalty_left, min(penalty_here0, penalty_diag));
	penalty_temp1 = INFINITY;
	penalty_here1 = (query_value-subject_value1)*(query_value-subject_value1) + min(penalty_here0, min(penalty_here1, penalty_temp0));
	penalty_temp0 = penalty_here2;
	penalty_here2 = (query_value-subject_value2)*(query_value-subject_value2) + min(penalty_here1, min(penalty_here2, penalty_temp1));
	penalty_temp1 = penalty_here3;
	penalty_here3 = (query_value-subject_value3)*(query_value-subject_value3) + min(penalty_here2, min(penalty_here3, penalty_temp0));
	penalty_temp0 = penalty_here4;
	penalty_here4 = (query_value-subject_value4)*(query_value-subject_value4) + min(penalty_here3, min(penalty_here4, penalty_temp1));
	penalty_temp1 = penalty_here5;
	penalty_here5 = (query_value-subject_value5)*(query_value-subject_value5) + min(penalty_here4, min(penalty_here5, penalty_temp0));
	penalty_temp0 = penalty_here6;
	penalty_here6 = (query_value-subject_value6)*(query_value-subject_value6) + min(penalty_here5, min(penalty_here6, penalty_temp1));
	penalty_temp1 = penalty_here7;
	penalty_here7 = (query_value-subject_value7)*(query_value-subject_value7) + min(penalty_here6, min(penalty_here7, penalty_temp0));
	penalty_temp0 = penalty_here8;
	penalty_here8 = (query_value-subject_value8)*(query_value-subject_value8) + min(penalty_here7, min(penalty_here8, penalty_temp1));
	penalty_temp1 = penalty_here9;
	penalty_here9 = (query_value-subject_value9)*(query_value-subject_value9) + min(penalty_here8, min(penalty_here9, penalty_temp0));
	penalty_temp0 = penalty_here10;
	penalty_here10 = (query_value-subject_value10)*(query_value-subject_value10) + min(penalty_here9, min(penalty_here10, penalty_temp1));
	penalty_temp1 = penalty_here11;
	penalty_here11 = (query_value-subject_value11)*(query_value-subject_value11) + min(penalty_here10, min(penalty_here11, penalty_temp0));
	penalty_temp0 = penalty_here12;
	penalty_here12 = (query_value-subject_value12)*(query_value-subject_value12) + min(penalty_here11, min(penalty_here12, penalty_temp1));
	penalty_temp1 = penalty_here13;
	penalty_here13 = (query_value-subject_value13)*(query_value-subject_value13) + min(penalty_here12, min(penalty_here13, penalty_temp0));
	penalty_temp0 = penalty_here14;
	penalty_here14 = (query_value-subject_value14)*(query_value-subject_value14) + min(penalty_here13, min(penalty_here14, penalty_temp1));
	penalty_temp1 = penalty_here15;
	penalty_here15 = (query_value-subject_value15)*(query_value-subject_value15) + min(penalty_here14, min(penalty_here15, penalty_temp0));
	penalty_temp0 = penalty_here16;
	penalty_here16 = (query_value-subject_value16)*(query_value-subject_value16) + min(penalty_here15, min(penalty_here16, penalty_temp1));
	penalty_temp1 = penalty_here17;
	penalty_here17 = (query_value-subject_value17)*(query_value-subject_value17) + min(penalty_here16, min(penalty_here17, penalty_temp0));
	penalty_here18 = (query_value-subject_value18)*(query_value-subject_value18) + min(penalty_here17, min(penalty_here18, penalty_temp1));

	query_value = __shfl_up_sync(0xFFFFFFFF, query_value, 1, 32);
	if (thid == 0) query_value = new_query_value;
	new_query_value = __shfl_down_sync(0xFFFFFFFF, new_query_value, 1, 32);
	counter++;

	penalty_diag = penalty_left;
	penalty_left = __shfl_up_sync(0xFFFFFFFF, penalty_here18, 1, 32);

	if (thid == 0) penalty_left = INFINITY;

	for (index_t k = 3; k < 857 ; k++) {
		const index_t i = k-l;

		penalty_temp0 = penalty_here0;
		penalty_here0 = (query_value-subject_value0) * (query_value-subject_value0) + min(penalty_left, min(penalty_here0, penalty_diag));
		penalty_temp1 = penalty_here1;
		penalty_here1 = (query_value-subject_value1) * (query_value-subject_value1) + min(penalty_here0, min(penalty_here1, penalty_temp0));
		penalty_temp0 = penalty_here2;
		penalty_here2 = (query_value-subject_value2) * (query_value-subject_value2) + min(penalty_here1, min(penalty_here2, penalty_temp1));
		penalty_temp1 = penalty_here3;
		penalty_here3 = (query_value-subject_value3) * (query_value-subject_value3) + min(penalty_here2, min(penalty_here3, penalty_temp0));
		penalty_temp0 = penalty_here4;
		penalty_here4 = (query_value-subject_value4) * (query_value-subject_value4) + min(penalty_here3, min(penalty_here4, penalty_temp1));
		penalty_temp1 = penalty_here5;
		penalty_here5 = (query_value-subject_value5) * (query_value-subject_value5) + min(penalty_here4, min(penalty_here5, penalty_temp0));
		penalty_temp0 = penalty_here6;
		penalty_here6 = (query_value-subject_value6) * (query_value-subject_value6) + min(penalty_here5, min(penalty_here6, penalty_temp1));
		penalty_temp1 = penalty_here7;
		penalty_here7 = (query_value-subject_value7) * (query_value-subject_value7) + min(penalty_here6, min(penalty_here7, penalty_temp0));
		penalty_temp0 = penalty_here8;
		penalty_here8 = (query_value-subject_value8) * (query_value-subject_value8) + min(penalty_here7, min(penalty_here8, penalty_temp1));
		penalty_temp1 = penalty_here9;
		penalty_here9 = (query_value-subject_value9) * (query_value-subject_value9) + min(penalty_here8, min(penalty_here9, penalty_temp0));
		penalty_temp0 = penalty_here10;
		penalty_here10 = (query_value-subject_value10) * (query_value-subject_value10) + min(penalty_here9, min(penalty_here10, penalty_temp1));
		penalty_temp1 = penalty_here11;
		penalty_here11 = (query_value-subject_value11) * (query_value-subject_value11) + min(penalty_here10, min(penalty_here11, penalty_temp0));
		penalty_temp0 = penalty_here12;
		penalty_here12 = (query_value-subject_value12) * (query_value-subject_value12) + min(penalty_here11, min(penalty_here12, penalty_temp1));
		penalty_temp1 = penalty_here13;
		penalty_here13 = (query_value-subject_value13) * (query_value-subject_value13) + min(penalty_here12, min(penalty_here13, penalty_temp0));
		penalty_temp0 = penalty_here14;
		penalty_here14 = (query_value-subject_value14) * (query_value-subject_value14) + min(penalty_here13, min(penalty_here14, penalty_temp1));
		penalty_temp1 = penalty_here15;
		penalty_here15 = (query_value-subject_value15) * (query_value-subject_value15) + min(penalty_here14, min(penalty_here15, penalty_temp0));
		penalty_temp0 = penalty_here16;
		penalty_here16 = (query_value-subject_value16) * (query_value-subject_value16) + min(penalty_here15, min(penalty_here16, penalty_temp1));
		penalty_temp1 = penalty_here17;
		penalty_here17 = (query_value-subject_value17) * (query_value-subject_value17) + min(penalty_here16, min(penalty_here17, penalty_temp0));
		penalty_here18 = (query_value-subject_value18) * (query_value-subject_value18) + min(penalty_here17, min(penalty_here18, penalty_temp1));

		if (counter%WARP_SIZE == 0) new_query_value = cQuery[i+2*thid-1];
		query_value = __shfl_up_sync(0xFFFFFFFF, query_value, 1, 32);
		if (thid == 0) query_value = new_query_value;
		new_query_value = __shfl_down_sync(0xFFFFFFFF, new_query_value, 1, 32);

		counter++;

		penalty_diag = penalty_left;
		penalty_left = __shfl_up_sync(0xFFFFFFFF, penalty_here18, 1, 32);

		if (thid == 0) penalty_left = INFINITY;
	}

	penalty_temp0 = penalty_here0;
	penalty_here0 = (query_value-subject_value0)*(query_value-subject_value0) + min(penalty_left, min(penalty_here0, penalty_diag));
	penalty_temp1 = penalty_here1;
	penalty_here1 = (query_value-subject_value1)*(query_value-subject_value1) + min(penalty_here0, min(penalty_here1, penalty_temp0));
	penalty_temp0 = penalty_here2;
	penalty_here2 = (query_value-subject_value2)*(query_value-subject_value2) + min(penalty_here1, min(penalty_here2, penalty_temp1));
	penalty_temp1 = penalty_here3;
	penalty_here3 = (query_value-subject_value3)*(query_value-subject_value3) + min(penalty_here2, min(penalty_here3, penalty_temp0));
	penalty_temp0 = penalty_here4;
	penalty_here4 = (query_value-subject_value4)*(query_value-subject_value4) + min(penalty_here3, min(penalty_here4, penalty_temp1));
	penalty_temp1 = penalty_here5;
	penalty_here5 = (query_value-subject_value5)*(query_value-subject_value5) + min(penalty_here4, min(penalty_here5, penalty_temp0));
	penalty_temp0 = penalty_here6;
	penalty_here6 = (query_value-subject_value6)*(query_value-subject_value6) + min(penalty_here5, min(penalty_here6, penalty_temp1));
	penalty_temp1 = penalty_here7;
	penalty_here7 = (query_value-subject_value7)*(query_value-subject_value7) + min(penalty_here6, min(penalty_here7, penalty_temp0));
	penalty_temp0 = penalty_here8;
	penalty_here8 = (query_value-subject_value8)*(query_value-subject_value8) + min(penalty_here7, min(penalty_here8, penalty_temp1));
	penalty_temp1 = penalty_here9;
	penalty_here9 = (query_value-subject_value9)*(query_value-subject_value9) + min(penalty_here8, min(penalty_here9, penalty_temp0));
	penalty_temp0 = penalty_here10;
	penalty_here10 = (query_value-subject_value10)*(query_value-subject_value10) + min(penalty_here9, min(penalty_here10, penalty_temp1));
	penalty_temp1 = penalty_here11;
	penalty_here11 = (query_value-subject_value11)*(query_value-subject_value11) + min(penalty_here10, min(penalty_here11, penalty_temp0));
	if(thid == 31)  Dist[blid] = sqrt( (float) penalty_here11);
}

#endif
