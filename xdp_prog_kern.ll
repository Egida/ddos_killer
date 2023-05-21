; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.log = type <{ i16, i16, i64, i64, %struct.tuples }>
%struct.tuples = type { i8, i32, i32, %struct.in6_addr, %struct.in6_addr, i8, i16, i16, i16, i8, i8 }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@my_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 60, i32 550, i32 0 }, section "maps", align 4, !dbg !0
@logger = dso_local global %struct.bpf_map_def { i32 4, i32 4, i32 4, i32 128, i32 0 }, section "maps", align 4, !dbg !28
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !38
@__const.send_perf_event.____fmt = private unnamed_addr constant [18 x i8] c"ERROR: %d %lu %d\0A\00", align 1
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @logger to i8*), i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_filter_func to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_filter_func(%struct.xdp_md* noundef %0) #0 section "xdp_filter" !dbg !139 {
  %2 = alloca [18 x i8], align 1
  %3 = alloca [18 x i8], align 1
  %4 = alloca %struct.log, align 2
  %5 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !152, metadata !DIExpression()), !dbg !401
  %6 = bitcast %struct.log* %4 to i8*, !dbg !402
  call void @llvm.lifetime.start.p0i8(i64 76, i8* nonnull %6) #6, !dbg !402
  call void @llvm.dbg.declare(metadata %struct.log* %4, metadata !153, metadata !DIExpression()), !dbg !403
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 2 dereferenceable(76) %6, i8 0, i64 76, i1 false), !dbg !404
  call void @llvm.dbg.value(metadata %struct.log* %4, metadata !201, metadata !DIExpression()), !dbg !401
  %7 = tail call i64 inttoptr (i64 5 to i64 ()*)() #6, !dbg !405
  %8 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 2, !dbg !406
  store i64 %7, i64* %8, align 2, !dbg !407, !tbaa !408
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !417
  %10 = load i32, i32* %9, align 4, !dbg !417, !tbaa !418
  %11 = zext i32 %10 to i64, !dbg !420
  %12 = inttoptr i64 %11 to i8*, !dbg !421
  call void @llvm.dbg.value(metadata i8* %12, metadata !203, metadata !DIExpression()), !dbg !401
  %13 = add nuw nsw i64 %11, 14, !dbg !422
  %14 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !424
  %15 = load i32, i32* %14, align 4, !dbg !424, !tbaa !425
  %16 = zext i32 %15 to i64, !dbg !426
  %17 = icmp ugt i64 %13, %16, !dbg !427
  br i1 %17, label %248, label %18, !dbg !428

18:                                               ; preds = %1
  %19 = inttoptr i64 %11 to %struct.ethhdr*, !dbg !421
  call void @llvm.dbg.value(metadata %struct.ethhdr* %19, metadata !203, metadata !DIExpression()), !dbg !401
  %20 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %19, i64 0, i32 2, !dbg !429
  %21 = load i16, i16* %20, align 1, !dbg !429, !tbaa !430
  switch i16 %21, label %248 [
    i16 8, label %22
    i16 -8826, label %70
  ], !dbg !432

22:                                               ; preds = %18
  call void @llvm.dbg.value(metadata i8* %12, metadata !216, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !433
  %23 = add nuw nsw i64 %11, 34, !dbg !434
  %24 = icmp ugt i64 %23, %16, !dbg !436
  br i1 %24, label %248, label %25, !dbg !437

25:                                               ; preds = %22
  %26 = getelementptr i8, i8* %12, i64 23, !dbg !438
  %27 = load i8, i8* %26, align 1, !dbg !438, !tbaa !439
  %28 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 5, !dbg !441
  store i8 %27, i8* %28, align 2, !dbg !442, !tbaa !443
  switch i8 %27, label %61 [
    i8 6, label %29
    i8 17, label %41
    i8 1, label %53
  ], !dbg !444

29:                                               ; preds = %25
  call void @llvm.dbg.value(metadata i8* %12, metadata !234, metadata !DIExpression(DW_OP_plus_uconst, 34, DW_OP_stack_value)), !dbg !445
  %30 = add nuw nsw i64 %11, 54, !dbg !446
  %31 = icmp ugt i64 %30, %16, !dbg !448
  br i1 %31, label %248, label %32, !dbg !449

32:                                               ; preds = %29
  %33 = getelementptr i8, i8* %12, i64 34, !dbg !450
  call void @llvm.dbg.value(metadata i8* %33, metadata !234, metadata !DIExpression()), !dbg !445
  call void @llvm.dbg.value(metadata i8* %33, metadata !234, metadata !DIExpression()), !dbg !445
  %34 = getelementptr i8, i8* %12, i64 36, !dbg !451
  %35 = bitcast i8* %34 to i16*, !dbg !451
  %36 = load i16, i16* %35, align 2, !dbg !451, !tbaa !452
  %37 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 7, !dbg !454
  store i16 %36, i16* %37, align 2, !dbg !455, !tbaa !456
  %38 = bitcast i8* %33 to i16*, !dbg !457
  %39 = load i16, i16* %38, align 4, !dbg !457, !tbaa !458
  %40 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 6, !dbg !459
  store i16 %39, i16* %40, align 2, !dbg !460, !tbaa !461
  br label %61

41:                                               ; preds = %25
  call void @llvm.dbg.value(metadata i8* %12, metadata !260, metadata !DIExpression(DW_OP_plus_uconst, 34, DW_OP_stack_value)), !dbg !462
  %42 = add nuw nsw i64 %11, 42, !dbg !463
  %43 = icmp ugt i64 %42, %16, !dbg !465
  br i1 %43, label %248, label %44, !dbg !466

44:                                               ; preds = %41
  %45 = getelementptr i8, i8* %12, i64 34, !dbg !467
  call void @llvm.dbg.value(metadata i8* %45, metadata !260, metadata !DIExpression()), !dbg !462
  call void @llvm.dbg.value(metadata i8* %45, metadata !260, metadata !DIExpression()), !dbg !462
  %46 = getelementptr i8, i8* %12, i64 36, !dbg !468
  %47 = bitcast i8* %46 to i16*, !dbg !468
  %48 = load i16, i16* %47, align 2, !dbg !468, !tbaa !469
  %49 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 7, !dbg !471
  store i16 %48, i16* %49, align 2, !dbg !472, !tbaa !456
  %50 = bitcast i8* %45 to i16*, !dbg !473
  %51 = load i16, i16* %50, align 2, !dbg !473, !tbaa !474
  %52 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 6, !dbg !475
  store i16 %51, i16* %52, align 2, !dbg !476, !tbaa !461
  br label %61

53:                                               ; preds = %25
  call void @llvm.dbg.value(metadata i8* %12, metadata !271, metadata !DIExpression(DW_OP_plus_uconst, 34, DW_OP_stack_value)), !dbg !477
  %54 = add nuw nsw i64 %11, 42, !dbg !478
  %55 = icmp ugt i64 %54, %16, !dbg !480
  br i1 %55, label %248, label %56, !dbg !481

56:                                               ; preds = %53
  call void @llvm.dbg.value(metadata i8* %12, metadata !271, metadata !DIExpression(DW_OP_plus_uconst, 34, DW_OP_stack_value)), !dbg !477
  call void @llvm.dbg.value(metadata i8* %12, metadata !271, metadata !DIExpression(DW_OP_plus_uconst, 34, DW_OP_stack_value)), !dbg !477
  %57 = getelementptr i8, i8* %12, i64 40, !dbg !482
  %58 = bitcast i8* %57 to i16*, !dbg !482
  %59 = load i16, i16* %58, align 2, !dbg !482, !tbaa !483
  %60 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 8, !dbg !484
  store i16 %59, i16* %60, align 2, !dbg !485, !tbaa !486
  br label %61

61:                                               ; preds = %25, %32, %44, %56
  %62 = getelementptr i8, i8* %12, i64 26, !dbg !487
  %63 = bitcast i8* %62 to i32*, !dbg !487
  %64 = load i32, i32* %63, align 4, !dbg !487, !tbaa !488
  %65 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 1, !dbg !489
  store i32 %64, i32* %65, align 2, !dbg !490, !tbaa !491
  %66 = getelementptr i8, i8* %12, i64 30, !dbg !492
  %67 = bitcast i8* %66 to i32*, !dbg !492
  %68 = load i32, i32* %67, align 4, !dbg !492, !tbaa !493
  %69 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 2, !dbg !494
  store i32 %68, i32* %69, align 2, !dbg !495, !tbaa !496
  br label %102

70:                                               ; preds = %18
  call void @llvm.dbg.value(metadata i8* %12, metadata !295, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !497
  %71 = add nuw nsw i64 %11, 54, !dbg !498
  %72 = icmp ugt i64 %71, %16, !dbg !500
  br i1 %72, label %248, label %73, !dbg !501

73:                                               ; preds = %70
  %74 = getelementptr i8, i8* %12, i64 20, !dbg !502
  %75 = load i8, i8* %74, align 2, !dbg !502, !tbaa !503
  %76 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 5, !dbg !505
  store i8 %75, i8* %76, align 2, !dbg !506, !tbaa !443
  switch i8 %75, label %95 [
    i8 6, label %77
    i8 17, label %80
    i8 58, label %83
  ], !dbg !507

77:                                               ; preds = %73
  call void @llvm.dbg.value(metadata i8* %12, metadata !325, metadata !DIExpression(DW_OP_plus_uconst, 54, DW_OP_stack_value)), !dbg !508
  %78 = add nuw nsw i64 %11, 74, !dbg !509
  %79 = icmp ugt i64 %78, %16, !dbg !511
  br i1 %79, label %248, label %86, !dbg !512

80:                                               ; preds = %73
  call void @llvm.dbg.value(metadata i8* %12, metadata !328, metadata !DIExpression(DW_OP_plus_uconst, 54, DW_OP_stack_value)), !dbg !513
  %81 = add nuw nsw i64 %11, 62, !dbg !514
  %82 = icmp ugt i64 %81, %16, !dbg !516
  br i1 %82, label %248, label %86, !dbg !517

83:                                               ; preds = %73
  call void @llvm.dbg.value(metadata i8* %12, metadata !331, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_plus_uconst, 40, DW_OP_stack_value)), !dbg !518
  %84 = add nuw nsw i64 %11, 62, !dbg !519
  %85 = icmp ugt i64 %84, %16, !dbg !521
  br i1 %85, label %248, label %95

86:                                               ; preds = %80, %77
  %87 = getelementptr i8, i8* %12, i64 56, !dbg !522
  %88 = bitcast i8* %87 to i16*, !dbg !522
  %89 = load i16, i16* %88, align 2, !dbg !522, !tbaa !523
  %90 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 7, !dbg !522
  store i16 %89, i16* %90, align 2, !dbg !522, !tbaa !456
  %91 = getelementptr i8, i8* %12, i64 54, !dbg !522
  %92 = bitcast i8* %91 to i16*, !dbg !522
  %93 = load i16, i16* %92, align 2, !dbg !522, !tbaa !523
  %94 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 6, !dbg !522
  store i16 %93, i16* %94, align 2, !dbg !522, !tbaa !461
  br label %95, !dbg !524

95:                                               ; preds = %86, %83, %73
  %96 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 3, !dbg !524
  %97 = getelementptr i8, i8* %12, i64 22, !dbg !525
  %98 = bitcast %struct.in6_addr* %96 to i8*, !dbg !525
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 2 dereferenceable(16) %98, i8* noundef nonnull align 4 dereferenceable(16) %97, i64 16, i1 false), !dbg !525, !tbaa.struct !526
  %99 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 4, !dbg !527
  %100 = getelementptr i8, i8* %12, i64 38, !dbg !528
  %101 = bitcast %struct.in6_addr* %99 to i8*, !dbg !528
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 2 dereferenceable(16) %101, i8* noundef nonnull align 4 dereferenceable(16) %100, i64 16, i1 false), !dbg !528, !tbaa.struct !526
  br label %102

102:                                              ; preds = %95, %61
  %103 = phi i8 [ 6, %95 ], [ 4, %61 ]
  %104 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 0, !dbg !529
  store i8 %103, i8* %104, align 2, !dbg !529, !tbaa !530
  call void @llvm.dbg.value(metadata i32 50, metadata !375, metadata !DIExpression()), !dbg !531
  %105 = bitcast i32* %5 to i8*
  call void @llvm.dbg.value(metadata i32 50, metadata !375, metadata !DIExpression()), !dbg !531
  %106 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 1
  %107 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 2
  %108 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 5
  %109 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 6
  %110 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 4, i32 7
  br label %111, !dbg !532

111:                                              ; preds = %102, %221
  %112 = phi i32 [ 50, %102 ], [ %222, %221 ]
  call void @llvm.dbg.value(metadata i32 %112, metadata !375, metadata !DIExpression()), !dbg !531
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %105) #6, !dbg !533
  call void @llvm.dbg.value(metadata i32 %112, metadata !377, metadata !DIExpression()), !dbg !534
  store i32 %112, i32* %5, align 4, !dbg !535, !tbaa !536
  call void @llvm.dbg.value(metadata i32* %5, metadata !377, metadata !DIExpression(DW_OP_deref)), !dbg !534
  %113 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @my_map to i8*), i8* noundef nonnull %105) #6, !dbg !537
  call void @llvm.dbg.value(metadata i8* %113, metadata !380, metadata !DIExpression()), !dbg !534
  %114 = icmp eq i8* %113, null, !dbg !538
  br i1 %114, label %219, label %115, !dbg !540

115:                                              ; preds = %111
  %116 = bitcast i8* %113 to i32*, !dbg !541
  %117 = load i32, i32* %116, align 4, !dbg !541, !tbaa !542
  %118 = icmp eq i32 %117, 0, !dbg !544
  br i1 %118, label %221, label %119, !dbg !545

119:                                              ; preds = %115
  call void @llvm.dbg.value(metadata i32 0, metadata !386, metadata !DIExpression()), !dbg !546
  %120 = getelementptr inbounds i8, i8* %113, i64 8, !dbg !547
  %121 = bitcast i8* %120 to i32*, !dbg !547
  %122 = load i32, i32* %121, align 4, !dbg !547, !tbaa !548
  %123 = icmp eq i32 %122, 0, !dbg !549
  br i1 %123, label %141, label %124, !dbg !550

124:                                              ; preds = %119
  %125 = getelementptr inbounds i8, i8* %113, i64 56, !dbg !551
  %126 = load i8, i8* %125, align 4, !dbg !551, !tbaa !552
  %127 = icmp eq i8 %126, 0, !dbg !553
  %128 = load i32, i32* %106, align 2, !dbg !554, !tbaa !491
  br i1 %127, label %138, label %129, !dbg !555

129:                                              ; preds = %124
  %130 = call i32 @llvm.bswap.i32(i32 %128), !dbg !556
  %131 = zext i8 %126 to i32, !dbg !557
  %132 = sub nsw i32 32, %131, !dbg !558
  %133 = lshr i32 %130, %132, !dbg !559
  call void @llvm.dbg.value(metadata i32 %133, metadata !389, metadata !DIExpression()), !dbg !560
  %134 = call i32 @llvm.bswap.i32(i32 %122), !dbg !561
  %135 = lshr i32 %134, %132, !dbg !562
  call void @llvm.dbg.value(metadata i32 %135, metadata !394, metadata !DIExpression()), !dbg !560
  %136 = icmp ne i32 %135, %133, !dbg !563
  %137 = zext i1 %136 to i32, !dbg !565
  call void @llvm.dbg.value(metadata i32 %137, metadata !386, metadata !DIExpression()), !dbg !546
  br label %141, !dbg !566

138:                                              ; preds = %124
  %139 = icmp eq i32 %128, %122, !dbg !567
  br i1 %139, label %141, label %140, !dbg !569

140:                                              ; preds = %138
  call void @llvm.dbg.value(metadata i32 1, metadata !386, metadata !DIExpression()), !dbg !546
  br label %141, !dbg !570

141:                                              ; preds = %129, %140, %138, %119
  %142 = phi i32 [ %137, %129 ], [ 1, %140 ], [ 0, %138 ], [ 0, %119 ], !dbg !546
  call void @llvm.dbg.value(metadata i32 %142, metadata !386, metadata !DIExpression()), !dbg !546
  %143 = getelementptr inbounds i8, i8* %113, i64 12, !dbg !572
  %144 = bitcast i8* %143 to i32*, !dbg !572
  %145 = load i32, i32* %144, align 4, !dbg !572, !tbaa !573
  %146 = icmp eq i32 %145, 0, !dbg !574
  br i1 %146, label %166, label %147, !dbg !575

147:                                              ; preds = %141
  %148 = getelementptr inbounds i8, i8* %113, i64 57, !dbg !576
  %149 = load i8, i8* %148, align 1, !dbg !576, !tbaa !577
  %150 = icmp eq i8 %149, 0, !dbg !578
  %151 = load i32, i32* %107, align 2, !dbg !579, !tbaa !496
  br i1 %150, label %162, label %152, !dbg !580

152:                                              ; preds = %147
  %153 = call i32 @llvm.bswap.i32(i32 %151), !dbg !581
  %154 = zext i8 %149 to i32, !dbg !582
  %155 = sub nsw i32 32, %154, !dbg !583
  %156 = lshr i32 %153, %155, !dbg !584
  call void @llvm.dbg.value(metadata i32 %156, metadata !395, metadata !DIExpression()), !dbg !585
  %157 = call i32 @llvm.bswap.i32(i32 %145), !dbg !586
  %158 = lshr i32 %157, %155, !dbg !587
  call void @llvm.dbg.value(metadata i32 %158, metadata !400, metadata !DIExpression()), !dbg !585
  %159 = icmp ne i32 %158, %156, !dbg !588
  %160 = zext i1 %159 to i32, !dbg !590
  %161 = add nuw nsw i32 %142, %160, !dbg !590
  call void @llvm.dbg.value(metadata i32 %161, metadata !386, metadata !DIExpression()), !dbg !546
  br label %166, !dbg !591

162:                                              ; preds = %147
  %163 = icmp eq i32 %151, %145, !dbg !592
  br i1 %163, label %166, label %164, !dbg !594

164:                                              ; preds = %162
  %165 = add nuw nsw i32 %142, 1, !dbg !595
  call void @llvm.dbg.value(metadata i32 %165, metadata !386, metadata !DIExpression()), !dbg !546
  br label %166, !dbg !597

166:                                              ; preds = %152, %164, %162, %141
  %167 = phi i32 [ %161, %152 ], [ %165, %164 ], [ %142, %162 ], [ %142, %141 ], !dbg !546
  call void @llvm.dbg.value(metadata i32 %167, metadata !386, metadata !DIExpression()), !dbg !546
  %168 = getelementptr inbounds i8, i8* %113, i64 48, !dbg !598
  %169 = load i8, i8* %168, align 4, !dbg !598, !tbaa !600
  %170 = icmp ne i8 %169, 0, !dbg !601
  %171 = load i8, i8* %108, align 2
  %172 = icmp ne i8 %171, %169
  %173 = select i1 %170, i1 %172, i1 false, !dbg !602
  %174 = zext i1 %173 to i32, !dbg !602
  %175 = add nuw nsw i32 %167, %174, !dbg !602
  call void @llvm.dbg.value(metadata i32 %175, metadata !386, metadata !DIExpression()), !dbg !546
  %176 = getelementptr inbounds i8, i8* %113, i64 50, !dbg !603
  %177 = bitcast i8* %176 to i16*, !dbg !603
  %178 = load i16, i16* %177, align 2, !dbg !603, !tbaa !605
  %179 = icmp ne i16 %178, 0, !dbg !606
  %180 = load i16, i16* %109, align 2
  %181 = icmp ne i16 %180, %178
  %182 = select i1 %179, i1 %181, i1 false, !dbg !607
  %183 = zext i1 %182 to i32, !dbg !607
  %184 = add nuw nsw i32 %175, %183, !dbg !607
  call void @llvm.dbg.value(metadata i32 %184, metadata !386, metadata !DIExpression()), !dbg !546
  %185 = getelementptr inbounds i8, i8* %113, i64 52, !dbg !608
  %186 = bitcast i8* %185 to i16*, !dbg !608
  %187 = load i16, i16* %186, align 4, !dbg !608, !tbaa !610
  %188 = icmp ne i16 %187, 0, !dbg !611
  %189 = load i16, i16* %110, align 2
  %190 = icmp ne i16 %189, %187
  %191 = select i1 %188, i1 %190, i1 false, !dbg !612
  %192 = sext i1 %191 to i32, !dbg !612
  call void @llvm.dbg.value(metadata !DIArgList(i32 %184, i1 %191), metadata !386, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_plus, DW_OP_stack_value)), !dbg !546
  %193 = icmp eq i32 %184, %192, !dbg !613
  br i1 %193, label %194, label %221, !dbg !615

194:                                              ; preds = %166
  switch i32 %117, label %221 [
    i32 1, label %219
    i32 2, label %195
  ], !dbg !616

195:                                              ; preds = %194
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !618, metadata !DIExpression()) #6, !dbg !637
  call void @llvm.dbg.value(metadata %struct.log* %4, metadata !623, metadata !DIExpression()) #6, !dbg !637
  %196 = load i32, i32* %14, align 4, !dbg !642, !tbaa !425
  %197 = zext i32 %196 to i64, !dbg !643
  %198 = inttoptr i64 %197 to i8*, !dbg !644
  call void @llvm.dbg.value(metadata i8* %198, metadata !624, metadata !DIExpression()) #6, !dbg !637
  %199 = load i32, i32* %9, align 4, !dbg !645, !tbaa !418
  %200 = zext i32 %199 to i64, !dbg !646
  %201 = inttoptr i64 %200 to i8*, !dbg !647
  call void @llvm.dbg.value(metadata i8* %201, metadata !625, metadata !DIExpression()) #6, !dbg !637
  %202 = icmp ult i8* %201, %198, !dbg !648
  br i1 %202, label %203, label %219, !dbg !649

203:                                              ; preds = %195
  call void @llvm.dbg.value(metadata %struct.log* %4, metadata !629, metadata !DIExpression()) #6, !dbg !650
  %204 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 0, !dbg !651
  store i16 -8531, i16* %204, align 2, !dbg !652, !tbaa !653
  %205 = sub i32 %196, %199, !dbg !654
  %206 = trunc i32 %205 to i16, !dbg !655
  %207 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 1, !dbg !656
  store i16 %206, i16* %207, align 2, !dbg !657, !tbaa !658
  %208 = call i64 inttoptr (i64 5 to i64 ()*)() #6, !dbg !659
  %209 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 3, !dbg !660
  store i64 %208, i64* %209, align 2, !dbg !661, !tbaa !662
  %210 = bitcast %struct.xdp_md* %0 to i8*, !dbg !663
  %211 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i64)*)(i8* noundef %210, i8* noundef bitcast (%struct.bpf_map_def* @logger to i8*), i64 noundef 4294967295, i8* noundef nonnull %6, i64 noundef 76) #6, !dbg !664
  call void @llvm.dbg.value(metadata i32 %211, metadata !626, metadata !DIExpression()) #6, !dbg !650
  %212 = icmp eq i32 %211, 0, !dbg !665
  br i1 %212, label %219, label %213, !dbg !666

213:                                              ; preds = %203
  %214 = getelementptr inbounds [18 x i8], [18 x i8]* %3, i64 0, i64 0, !dbg !667
  call void @llvm.lifetime.start.p0i8(i64 18, i8* nonnull %214) #6, !dbg !667
  call void @llvm.dbg.declare(metadata [18 x i8]* %3, metadata !630, metadata !DIExpression()) #6, !dbg !667
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(18) %214, i8* noundef nonnull align 1 dereferenceable(18) getelementptr inbounds ([18 x i8], [18 x i8]* @__const.send_perf_event.____fmt, i64 0, i64 0), i64 18, i1 false) #6, !dbg !667
  %215 = load i64, i64* %209, align 2, !dbg !667, !tbaa !662
  %216 = load i64, i64* %8, align 2, !dbg !667, !tbaa !408
  %217 = sub i64 %215, %216, !dbg !667
  %218 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %214, i32 noundef 18, i32 noundef %211, i64 noundef 4294967295, i64 noundef %217) #6, !dbg !667
  call void @llvm.lifetime.end.p0i8(i64 18, i8* nonnull %214) #6, !dbg !668
  br label %219, !dbg !669

219:                                              ; preds = %111, %194, %195, %203, %213
  %220 = phi i32 [ 2, %213 ], [ 2, %203 ], [ 2, %195 ], [ 2, %111 ], [ %117, %194 ], !dbg !534
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %105) #6, !dbg !670
  br label %248

221:                                              ; preds = %194, %166, %115
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %105) #6, !dbg !670
  %222 = add nuw nsw i32 %112, 1, !dbg !671
  call void @llvm.dbg.value(metadata i32 %222, metadata !375, metadata !DIExpression()), !dbg !531
  %223 = icmp eq i32 %222, 550, !dbg !672
  br i1 %223, label %224, label %111, !dbg !532, !llvm.loop !673

224:                                              ; preds = %221
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !618, metadata !DIExpression()) #6, !dbg !676
  call void @llvm.dbg.value(metadata %struct.log* %4, metadata !623, metadata !DIExpression()) #6, !dbg !676
  %225 = load i32, i32* %14, align 4, !dbg !678, !tbaa !425
  %226 = zext i32 %225 to i64, !dbg !679
  %227 = inttoptr i64 %226 to i8*, !dbg !680
  call void @llvm.dbg.value(metadata i8* %227, metadata !624, metadata !DIExpression()) #6, !dbg !676
  %228 = load i32, i32* %9, align 4, !dbg !681, !tbaa !418
  %229 = zext i32 %228 to i64, !dbg !682
  %230 = inttoptr i64 %229 to i8*, !dbg !683
  call void @llvm.dbg.value(metadata i8* %230, metadata !625, metadata !DIExpression()) #6, !dbg !676
  %231 = icmp ult i8* %230, %227, !dbg !684
  br i1 %231, label %232, label %248, !dbg !685

232:                                              ; preds = %224
  call void @llvm.dbg.value(metadata %struct.log* %4, metadata !629, metadata !DIExpression()) #6, !dbg !686
  %233 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 0, !dbg !687
  store i16 -8531, i16* %233, align 2, !dbg !688, !tbaa !653
  %234 = sub i32 %225, %228, !dbg !689
  %235 = trunc i32 %234 to i16, !dbg !690
  %236 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 1, !dbg !691
  store i16 %235, i16* %236, align 2, !dbg !692, !tbaa !658
  %237 = call i64 inttoptr (i64 5 to i64 ()*)() #6, !dbg !693
  %238 = getelementptr inbounds %struct.log, %struct.log* %4, i64 0, i32 3, !dbg !694
  store i64 %237, i64* %238, align 2, !dbg !695, !tbaa !662
  %239 = bitcast %struct.xdp_md* %0 to i8*, !dbg !696
  %240 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i64)*)(i8* noundef %239, i8* noundef bitcast (%struct.bpf_map_def* @logger to i8*), i64 noundef 4294967295, i8* noundef nonnull %6, i64 noundef 76) #6, !dbg !697
  call void @llvm.dbg.value(metadata i32 %240, metadata !626, metadata !DIExpression()) #6, !dbg !686
  %241 = icmp eq i32 %240, 0, !dbg !698
  br i1 %241, label %248, label %242, !dbg !699

242:                                              ; preds = %232
  %243 = getelementptr inbounds [18 x i8], [18 x i8]* %2, i64 0, i64 0, !dbg !700
  call void @llvm.lifetime.start.p0i8(i64 18, i8* nonnull %243) #6, !dbg !700
  call void @llvm.dbg.declare(metadata [18 x i8]* %2, metadata !630, metadata !DIExpression()) #6, !dbg !700
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(18) %243, i8* noundef nonnull align 1 dereferenceable(18) getelementptr inbounds ([18 x i8], [18 x i8]* @__const.send_perf_event.____fmt, i64 0, i64 0), i64 18, i1 false) #6, !dbg !700
  %244 = load i64, i64* %238, align 2, !dbg !700, !tbaa !662
  %245 = load i64, i64* %8, align 2, !dbg !700, !tbaa !408
  %246 = sub i64 %244, %245, !dbg !700
  %247 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* noundef nonnull %243, i32 noundef 18, i32 noundef %240, i64 noundef 4294967295, i64 noundef %246) #6, !dbg !700
  call void @llvm.lifetime.end.p0i8(i64 18, i8* nonnull %243) #6, !dbg !701
  br label %248, !dbg !702

248:                                              ; preds = %80, %77, %70, %83, %53, %41, %29, %22, %242, %232, %224, %219, %18, %1
  %249 = phi i32 [ 2, %1 ], [ 2, %18 ], [ %220, %219 ], [ 2, %224 ], [ 2, %232 ], [ 2, %242 ], [ 0, %53 ], [ 0, %41 ], [ 0, %29 ], [ 2, %22 ], [ 0, %80 ], [ 0, %77 ], [ 2, %70 ], [ 0, %83 ], !dbg !401
  call void @llvm.lifetime.end.p0i8(i64 76, i8* nonnull %6) #6, !dbg !703
  ret i32 %249, !dbg !703
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!134, !135, !136, !137}
!llvm.ident = !{!138}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_map", scope: !2, file: !3, line: 61, type: !30, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !20, globals: !27, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/mirai/ebpf_pfilt/ebpf_pfilt_adv", checksumkind: CSK_MD5, checksum: "f6d58d39c9f587d4913f4b6c777350cf")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 5431, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "5ad8bc925dae1ec87bbb04b3148b183b")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 5123, baseType: !15, size: 64, elements: !16)
!15 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!16 = !{!17, !18, !19}
!17 = !DIEnumerator(name: "BPF_F_INDEX_MASK", value: 4294967295, isUnsigned: true)
!18 = !DIEnumerator(name: "BPF_F_CURRENT_CPU", value: 4294967295, isUnsigned: true)
!19 = !DIEnumerator(name: "BPF_F_CTXLEN_MASK", value: 4503595332403200, isUnsigned: true)
!20 = !{!21, !22, !23, !26}
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!22 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !24, line: 24, baseType: !25)
!24 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!25 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !24, line: 27, baseType: !7)
!27 = !{!0, !28, !38, !44, !105, !107, !115, !122, !127}
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "logger", scope: !2, file: !3, line: 68, type: !30, isLocal: false, isDefinition: true)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !31, line: 33, size: 160, elements: !32)
!31 = !DIFile(filename: "./libbpf/src/bpf_helpers.h", directory: "/home/mirai/ebpf_pfilt/ebpf_pfilt_adv", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!32 = !{!33, !34, !35, !36, !37}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !30, file: !31, line: 34, baseType: !7, size: 32)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !30, file: !31, line: 35, baseType: !7, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !30, file: !31, line: 36, baseType: !7, size: 32, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !30, file: !31, line: 37, baseType: !7, size: 32, offset: 96)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !30, file: !31, line: 38, baseType: !7, size: 32, offset: 128)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 310, type: !40, isLocal: false, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 32, elements: !42)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !{!43}
!43 = !DISubrange(count: 4)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !46, line: 143, type: !47, isLocal: false, isDefinition: false)
!46 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "f31eefcc3f15835fc5a4023a625cf609")
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !49, line: 7, baseType: !50)
!49 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !51, line: 49, size: 1728, elements: !52)
!51 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "1bad07471b7974df4ecc1d1c2ca207e6")
!52 = !{!53, !55, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !70, !72, !73, !74, !77, !78, !80, !84, !87, !89, !92, !95, !96, !97, !100, !101}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !50, file: !51, line: 51, baseType: !54, size: 32)
!54 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !50, file: !51, line: 54, baseType: !56, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !50, file: !51, line: 55, baseType: !56, size: 64, offset: 128)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !50, file: !51, line: 56, baseType: !56, size: 64, offset: 192)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !50, file: !51, line: 57, baseType: !56, size: 64, offset: 256)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !50, file: !51, line: 58, baseType: !56, size: 64, offset: 320)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !50, file: !51, line: 59, baseType: !56, size: 64, offset: 384)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !50, file: !51, line: 60, baseType: !56, size: 64, offset: 448)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !50, file: !51, line: 61, baseType: !56, size: 64, offset: 512)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !50, file: !51, line: 64, baseType: !56, size: 64, offset: 576)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !50, file: !51, line: 65, baseType: !56, size: 64, offset: 640)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !50, file: !51, line: 66, baseType: !56, size: 64, offset: 704)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !50, file: !51, line: 68, baseType: !68, size: 64, offset: 768)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !51, line: 36, flags: DIFlagFwdDecl)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !50, file: !51, line: 70, baseType: !71, size: 64, offset: 832)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !50, file: !51, line: 72, baseType: !54, size: 32, offset: 896)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !50, file: !51, line: 73, baseType: !54, size: 32, offset: 928)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !50, file: !51, line: 74, baseType: !75, size: 64, offset: 960)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !76, line: 152, baseType: !22)
!76 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !50, file: !51, line: 77, baseType: !25, size: 16, offset: 1024)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !50, file: !51, line: 78, baseType: !79, size: 8, offset: 1040)
!79 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !50, file: !51, line: 79, baseType: !81, size: 8, offset: 1048)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 8, elements: !82)
!82 = !{!83}
!83 = !DISubrange(count: 1)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !50, file: !51, line: 81, baseType: !85, size: 64, offset: 1088)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !51, line: 43, baseType: null)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !50, file: !51, line: 89, baseType: !88, size: 64, offset: 1152)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !76, line: 153, baseType: !22)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !50, file: !51, line: 91, baseType: !90, size: 64, offset: 1216)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !51, line: 37, flags: DIFlagFwdDecl)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !50, file: !51, line: 92, baseType: !93, size: 64, offset: 1280)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !51, line: 38, flags: DIFlagFwdDecl)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !50, file: !51, line: 93, baseType: !71, size: 64, offset: 1344)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !50, file: !51, line: 94, baseType: !21, size: 64, offset: 1408)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !50, file: !51, line: 95, baseType: !98, size: 64, offset: 1472)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !99, line: 46, baseType: !15)
!99 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!100 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !50, file: !51, line: 96, baseType: !54, size: 32, offset: 1536)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !50, file: !51, line: 98, baseType: !102, size: 160, offset: 1568)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 160, elements: !103)
!103 = !{!104}
!104 = !DISubrange(count: 20)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !46, line: 144, type: !47, isLocal: false, isDefinition: false)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(name: "bpf_ktime_get_ns", scope: !2, file: !109, line: 89, type: !110, isLocal: true, isDefinition: true)
!109 = !DIFile(filename: "./libbpf/src/bpf_helper_defs.h", directory: "/home/mirai/ebpf_pfilt/ebpf_pfilt_adv", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = !DISubroutineType(types: !112)
!112 = !{!113}
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !24, line: 31, baseType: !114)
!114 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !109, line: 33, type: !117, isLocal: true, isDefinition: true)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DISubroutineType(types: !119)
!119 = !{!21, !21, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!122 = !DIGlobalVariableExpression(var: !123, expr: !DIExpression())
!123 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !109, line: 666, type: !124, isLocal: true, isDefinition: true)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DISubroutineType(types: !126)
!126 = !{!54, !21, !21, !113, !21, !113}
!127 = !DIGlobalVariableExpression(var: !128, expr: !DIExpression())
!128 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !109, line: 152, type: !129, isLocal: true, isDefinition: true)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = !DISubroutineType(types: !131)
!131 = !{!54, !132, !26, null}
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!134 = !{i32 7, !"Dwarf Version", i32 5}
!135 = !{i32 2, !"Debug Info Version", i32 3}
!136 = !{i32 1, !"wchar_size", i32 4}
!137 = !{i32 7, !"frame-pointer", i32 2}
!138 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!139 = distinct !DISubprogram(name: "xdp_filter_func", scope: !3, file: !3, line: 98, type: !140, scopeLine: 99, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !151)
!140 = !DISubroutineType(types: !141)
!141 = !{!54, !142}
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 5442, size: 192, elements: !144)
!144 = !{!145, !146, !147, !148, !149, !150}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !143, file: !6, line: 5443, baseType: !26, size: 32)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !143, file: !6, line: 5444, baseType: !26, size: 32, offset: 32)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !143, file: !6, line: 5445, baseType: !26, size: 32, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !143, file: !6, line: 5447, baseType: !26, size: 32, offset: 96)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !143, file: !6, line: 5448, baseType: !26, size: 32, offset: 128)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !143, file: !6, line: 5450, baseType: !26, size: 32, offset: 160)
!151 = !{!152, !153, !201, !203, !216, !234, !260, !271, !295, !325, !328, !331, !375, !377, !380, !386, !389, !394, !395, !400}
!152 = !DILocalVariable(name: "ctx", arg: 1, scope: !139, file: !3, line: 98, type: !142)
!153 = !DILocalVariable(name: "tm", scope: !139, file: !3, line: 100, type: !154)
!154 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "log", file: !3, line: 46, size: 608, elements: !155)
!155 = !{!156, !157, !158, !159, !160}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "cookie", scope: !154, file: !3, line: 48, baseType: !23, size: 16)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !154, file: !3, line: 49, baseType: !23, size: 16, offset: 16)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "ts_pre", scope: !154, file: !3, line: 50, baseType: !113, size: 64, offset: 32)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "ts_post", scope: !154, file: !3, line: 51, baseType: !113, size: 64, offset: 96)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !154, file: !3, line: 52, baseType: !161, size: 448, offset: 160)
!161 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tuples", file: !3, line: 31, size: 448, elements: !162)
!162 = !{!163, !168, !172, !173, !193, !194, !195, !196, !197, !199, !200}
!163 = !DIDerivedType(tag: DW_TAG_member, name: "ip_version", scope: !161, file: !3, line: 33, baseType: !164, size: 8)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !165, line: 24, baseType: !166)
!165 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !76, line: 38, baseType: !167)
!167 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "ip_src", scope: !161, file: !3, line: 34, baseType: !169, size: 32, offset: 32)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "u_int32_t", file: !170, line: 160, baseType: !171)
!170 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/sys/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e62424071ad3f1b4d088c139fd9ccfd1")
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !76, line: 42, baseType: !7)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "ip_dest", scope: !161, file: !3, line: 35, baseType: !169, size: 32, offset: 64)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "ip6_src", scope: !161, file: !3, line: 36, baseType: !174, size: 128, offset: 96)
!174 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !175, line: 219, size: 128, elements: !176)
!175 = !DIFile(filename: "/usr/include/netinet/in.h", directory: "", checksumkind: CSK_MD5, checksum: "eb6560f10d4cfe9f30fea2c92b9da0fd")
!176 = !{!177}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "__in6_u", scope: !174, file: !175, line: 226, baseType: !178, size: 128)
!178 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !174, file: !175, line: 221, size: 128, elements: !179)
!179 = !{!180, !184, !190}
!180 = !DIDerivedType(tag: DW_TAG_member, name: "__u6_addr8", scope: !178, file: !175, line: 223, baseType: !181, size: 128)
!181 = !DICompositeType(tag: DW_TAG_array_type, baseType: !164, size: 128, elements: !182)
!182 = !{!183}
!183 = !DISubrange(count: 16)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "__u6_addr16", scope: !178, file: !175, line: 224, baseType: !185, size: 128)
!185 = !DICompositeType(tag: DW_TAG_array_type, baseType: !186, size: 128, elements: !188)
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !165, line: 25, baseType: !187)
!187 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !76, line: 40, baseType: !25)
!188 = !{!189}
!189 = !DISubrange(count: 8)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "__u6_addr32", scope: !178, file: !175, line: 225, baseType: !191, size: 128)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !192, size: 128, elements: !42)
!192 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !165, line: 26, baseType: !171)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "ip6_dest", scope: !161, file: !3, line: 37, baseType: !174, size: 128, offset: 224)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !161, file: !3, line: 38, baseType: !164, size: 8, offset: 352)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "port_src", scope: !161, file: !3, line: 39, baseType: !23, size: 16, offset: 368)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "port_dest", scope: !161, file: !3, line: 40, baseType: !23, size: 16, offset: 384)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "icmp_sequence", scope: !161, file: !3, line: 41, baseType: !198, size: 16, offset: 400)
!198 = !DIDerivedType(tag: DW_TAG_typedef, name: "u_int16_t", file: !170, line: 159, baseType: !187)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "source_cidr", scope: !161, file: !3, line: 42, baseType: !167, size: 8, offset: 416)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "dest_cidr", scope: !161, file: !3, line: 43, baseType: !167, size: 8, offset: 424)
!201 = !DILocalVariable(name: "tmp", scope: !139, file: !3, line: 102, type: !202)
!202 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!203 = !DILocalVariable(name: "eth", scope: !139, file: !3, line: 105, type: !204)
!204 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !205, size: 64)
!205 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !206, line: 168, size: 112, elements: !207)
!206 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!207 = !{!208, !212, !213}
!208 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !205, file: !206, line: 169, baseType: !209, size: 48)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !167, size: 48, elements: !210)
!210 = !{!211}
!211 = !DISubrange(count: 6)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !205, file: !206, line: 170, baseType: !209, size: 48, offset: 48)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !205, file: !206, line: 171, baseType: !214, size: 16, offset: 96)
!214 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !215, line: 25, baseType: !23)
!215 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!216 = !DILocalVariable(name: "ip", scope: !217, file: !3, line: 114, type: !219)
!217 = distinct !DILexicalBlock(scope: !218, file: !3, line: 112, column: 9)
!218 = distinct !DILexicalBlock(scope: !139, file: !3, line: 111, column: 13)
!219 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !220, size: 64)
!220 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !221, line: 44, size: 160, elements: !222)
!221 = !DIFile(filename: "/usr/include/netinet/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "777a3c26c651c3cea644451d8391a76c")
!222 = !{!223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233}
!223 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !220, file: !221, line: 47, baseType: !7, size: 4, flags: DIFlagBitField, extraData: i64 0)
!224 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !220, file: !221, line: 48, baseType: !7, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !220, file: !221, line: 55, baseType: !164, size: 8, offset: 8)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !220, file: !221, line: 56, baseType: !186, size: 16, offset: 16)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !220, file: !221, line: 57, baseType: !186, size: 16, offset: 32)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !220, file: !221, line: 58, baseType: !186, size: 16, offset: 48)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !220, file: !221, line: 59, baseType: !164, size: 8, offset: 64)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !220, file: !221, line: 60, baseType: !164, size: 8, offset: 72)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !220, file: !221, line: 61, baseType: !186, size: 16, offset: 80)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !220, file: !221, line: 62, baseType: !192, size: 32, offset: 96)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !220, file: !221, line: 63, baseType: !192, size: 32, offset: 128)
!234 = !DILocalVariable(name: "tcp", scope: !235, file: !3, line: 123, type: !237)
!235 = distinct !DILexicalBlock(scope: !236, file: !3, line: 122, column: 17)
!236 = distinct !DILexicalBlock(scope: !217, file: !3, line: 121, column: 21)
!237 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !238, size: 64)
!238 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !239, line: 25, size: 160, elements: !240)
!239 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "8d74bf2133e7b3dab885994b9916aa13")
!240 = !{!241, !242, !243, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !259}
!241 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !238, file: !239, line: 26, baseType: !214, size: 16)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !238, file: !239, line: 27, baseType: !214, size: 16, offset: 16)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !238, file: !239, line: 28, baseType: !244, size: 32, offset: 32)
!244 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !215, line: 27, baseType: !26)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !238, file: !239, line: 29, baseType: !244, size: 32, offset: 64)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !238, file: !239, line: 31, baseType: !23, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !238, file: !239, line: 32, baseType: !23, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !238, file: !239, line: 33, baseType: !23, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !238, file: !239, line: 34, baseType: !23, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !238, file: !239, line: 35, baseType: !23, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !238, file: !239, line: 36, baseType: !23, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !238, file: !239, line: 37, baseType: !23, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !238, file: !239, line: 38, baseType: !23, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !238, file: !239, line: 39, baseType: !23, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !238, file: !239, line: 40, baseType: !23, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!256 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !238, file: !239, line: 55, baseType: !214, size: 16, offset: 112)
!257 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !238, file: !239, line: 56, baseType: !258, size: 16, offset: 128)
!258 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !215, line: 31, baseType: !23)
!259 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !238, file: !239, line: 57, baseType: !214, size: 16, offset: 144)
!260 = !DILocalVariable(name: "udp", scope: !261, file: !3, line: 133, type: !263)
!261 = distinct !DILexicalBlock(scope: !262, file: !3, line: 132, column: 17)
!262 = distinct !DILexicalBlock(scope: !236, file: !3, line: 131, column: 26)
!263 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !264, size: 64)
!264 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !265, line: 23, size: 64, elements: !266)
!265 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!266 = !{!267, !268, !269, !270}
!267 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !264, file: !265, line: 24, baseType: !214, size: 16)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !264, file: !265, line: 25, baseType: !214, size: 16, offset: 16)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !264, file: !265, line: 26, baseType: !214, size: 16, offset: 32)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !264, file: !265, line: 27, baseType: !258, size: 16, offset: 48)
!271 = !DILocalVariable(name: "icmp", scope: !272, file: !3, line: 143, type: !274)
!272 = distinct !DILexicalBlock(scope: !273, file: !3, line: 142, column: 17)
!273 = distinct !DILexicalBlock(scope: !262, file: !3, line: 141, column: 26)
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !275, size: 64)
!275 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr", file: !276, line: 26, size: 64, elements: !277)
!276 = !DIFile(filename: "/usr/include/netinet/ip_icmp.h", directory: "", checksumkind: CSK_MD5, checksum: "74f74dc2c6a8ce26bfc626b951e4165e")
!277 = !{!278, !279, !280, !281}
!278 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !275, file: !276, line: 28, baseType: !164, size: 8)
!279 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !275, file: !276, line: 29, baseType: !164, size: 8, offset: 8)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !275, file: !276, line: 30, baseType: !186, size: 16, offset: 16)
!281 = !DIDerivedType(tag: DW_TAG_member, name: "un", scope: !275, file: !276, line: 44, baseType: !282, size: 32, offset: 32)
!282 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !275, file: !276, line: 31, size: 32, elements: !283)
!283 = !{!284, !289, !290}
!284 = !DIDerivedType(tag: DW_TAG_member, name: "echo", scope: !282, file: !276, line: 37, baseType: !285, size: 32)
!285 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !282, file: !276, line: 33, size: 32, elements: !286)
!286 = !{!287, !288}
!287 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !285, file: !276, line: 35, baseType: !186, size: 16)
!288 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !285, file: !276, line: 36, baseType: !186, size: 16, offset: 16)
!289 = !DIDerivedType(tag: DW_TAG_member, name: "gateway", scope: !282, file: !276, line: 38, baseType: !192, size: 32)
!290 = !DIDerivedType(tag: DW_TAG_member, name: "frag", scope: !282, file: !276, line: 43, baseType: !291, size: 32)
!291 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !282, file: !276, line: 39, size: 32, elements: !292)
!292 = !{!293, !294}
!293 = !DIDerivedType(tag: DW_TAG_member, name: "__glibc_reserved", scope: !291, file: !276, line: 41, baseType: !186, size: 16)
!294 = !DIDerivedType(tag: DW_TAG_member, name: "mtu", scope: !291, file: !276, line: 42, baseType: !186, size: 16, offset: 16)
!295 = !DILocalVariable(name: "ip", scope: !296, file: !3, line: 157, type: !298)
!296 = distinct !DILexicalBlock(scope: !297, file: !3, line: 155, column: 59)
!297 = distinct !DILexicalBlock(scope: !218, file: !3, line: 155, column: 20)
!298 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !299, size: 64)
!299 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !300, line: 117, size: 320, elements: !301)
!300 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "0a3e356f53cd1c3f0cebfdeaff4287e2")
!301 = !{!302, !304, !305, !309, !310, !311, !312}
!302 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !299, file: !300, line: 119, baseType: !303, size: 4, flags: DIFlagBitField, extraData: i64 0)
!303 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !24, line: 21, baseType: !167)
!304 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !299, file: !300, line: 120, baseType: !303, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!305 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !299, file: !300, line: 127, baseType: !306, size: 24, offset: 8)
!306 = !DICompositeType(tag: DW_TAG_array_type, baseType: !303, size: 24, elements: !307)
!307 = !{!308}
!308 = !DISubrange(count: 3)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !299, file: !300, line: 129, baseType: !214, size: 16, offset: 32)
!310 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !299, file: !300, line: 130, baseType: !303, size: 8, offset: 48)
!311 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !299, file: !300, line: 131, baseType: !303, size: 8, offset: 56)
!312 = !DIDerivedType(tag: DW_TAG_member, scope: !299, file: !300, line: 133, baseType: !313, size: 256, offset: 64)
!313 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !299, file: !300, line: 133, size: 256, elements: !314)
!314 = !{!315, !320}
!315 = !DIDerivedType(tag: DW_TAG_member, scope: !313, file: !300, line: 133, baseType: !316, size: 256)
!316 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !313, file: !300, line: 133, size: 256, elements: !317)
!317 = !{!318, !319}
!318 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !316, file: !300, line: 133, baseType: !174, size: 128)
!319 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !316, file: !300, line: 133, baseType: !174, size: 128, offset: 128)
!320 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !313, file: !300, line: 133, baseType: !321, size: 256)
!321 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !313, file: !300, line: 133, size: 256, elements: !322)
!322 = !{!323, !324}
!323 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !321, file: !300, line: 133, baseType: !174, size: 128)
!324 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !321, file: !300, line: 133, baseType: !174, size: 128, offset: 128)
!325 = !DILocalVariable(name: "tcp", scope: !326, file: !3, line: 166, type: !237)
!326 = distinct !DILexicalBlock(scope: !327, file: !3, line: 165, column: 17)
!327 = distinct !DILexicalBlock(scope: !296, file: !3, line: 164, column: 21)
!328 = !DILocalVariable(name: "udp", scope: !329, file: !3, line: 176, type: !263)
!329 = distinct !DILexicalBlock(scope: !330, file: !3, line: 175, column: 17)
!330 = distinct !DILexicalBlock(scope: !327, file: !3, line: 174, column: 26)
!331 = !DILocalVariable(name: "icmp", scope: !332, file: !3, line: 186, type: !334)
!332 = distinct !DILexicalBlock(scope: !333, file: !3, line: 185, column: 17)
!333 = distinct !DILexicalBlock(scope: !330, file: !3, line: 184, column: 26)
!334 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !335, size: 64)
!335 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmp6hdr", file: !336, line: 8, size: 64, elements: !337)
!336 = !DIFile(filename: "/usr/include/linux/icmpv6.h", directory: "", checksumkind: CSK_MD5, checksum: "0310ca5584e6f44f6eea6cf040ee84b9")
!337 = !{!338, !339, !340, !341}
!338 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_type", scope: !335, file: !336, line: 10, baseType: !303, size: 8)
!339 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_code", scope: !335, file: !336, line: 11, baseType: !303, size: 8, offset: 8)
!340 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_cksum", scope: !335, file: !336, line: 12, baseType: !258, size: 16, offset: 16)
!341 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_dataun", scope: !335, file: !336, line: 63, baseType: !342, size: 32, offset: 32)
!342 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !335, file: !336, line: 15, size: 32, elements: !343)
!343 = !{!344, !346, !350, !352, !357, !365}
!344 = !DIDerivedType(tag: DW_TAG_member, name: "un_data32", scope: !342, file: !336, line: 16, baseType: !345, size: 32)
!345 = !DICompositeType(tag: DW_TAG_array_type, baseType: !244, size: 32, elements: !82)
!346 = !DIDerivedType(tag: DW_TAG_member, name: "un_data16", scope: !342, file: !336, line: 17, baseType: !347, size: 32)
!347 = !DICompositeType(tag: DW_TAG_array_type, baseType: !214, size: 32, elements: !348)
!348 = !{!349}
!349 = !DISubrange(count: 2)
!350 = !DIDerivedType(tag: DW_TAG_member, name: "un_data8", scope: !342, file: !336, line: 18, baseType: !351, size: 32)
!351 = !DICompositeType(tag: DW_TAG_array_type, baseType: !303, size: 32, elements: !42)
!352 = !DIDerivedType(tag: DW_TAG_member, name: "u_echo", scope: !342, file: !336, line: 23, baseType: !353, size: 32)
!353 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_echo", file: !336, line: 20, size: 32, elements: !354)
!354 = !{!355, !356}
!355 = !DIDerivedType(tag: DW_TAG_member, name: "identifier", scope: !353, file: !336, line: 21, baseType: !214, size: 16)
!356 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !353, file: !336, line: 22, baseType: !214, size: 16, offset: 16)
!357 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_advt", scope: !342, file: !336, line: 40, baseType: !358, size: 32)
!358 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_advt", file: !336, line: 25, size: 32, elements: !359)
!359 = !{!360, !361, !362, !363, !364}
!360 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !358, file: !336, line: 27, baseType: !26, size: 5, flags: DIFlagBitField, extraData: i64 0)
!361 = !DIDerivedType(tag: DW_TAG_member, name: "override", scope: !358, file: !336, line: 28, baseType: !26, size: 1, offset: 5, flags: DIFlagBitField, extraData: i64 0)
!362 = !DIDerivedType(tag: DW_TAG_member, name: "solicited", scope: !358, file: !336, line: 29, baseType: !26, size: 1, offset: 6, flags: DIFlagBitField, extraData: i64 0)
!363 = !DIDerivedType(tag: DW_TAG_member, name: "router", scope: !358, file: !336, line: 30, baseType: !26, size: 1, offset: 7, flags: DIFlagBitField, extraData: i64 0)
!364 = !DIDerivedType(tag: DW_TAG_member, name: "reserved2", scope: !358, file: !336, line: 31, baseType: !26, size: 24, offset: 8, flags: DIFlagBitField, extraData: i64 0)
!365 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_ra", scope: !342, file: !336, line: 61, baseType: !366, size: 32)
!366 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_ra", file: !336, line: 42, size: 32, elements: !367)
!367 = !{!368, !369, !370, !371, !372, !373, !374}
!368 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !366, file: !336, line: 43, baseType: !303, size: 8)
!369 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !366, file: !336, line: 45, baseType: !303, size: 3, offset: 8, flags: DIFlagBitField, extraData: i64 8)
!370 = !DIDerivedType(tag: DW_TAG_member, name: "router_pref", scope: !366, file: !336, line: 46, baseType: !303, size: 2, offset: 11, flags: DIFlagBitField, extraData: i64 8)
!371 = !DIDerivedType(tag: DW_TAG_member, name: "home_agent", scope: !366, file: !336, line: 47, baseType: !303, size: 1, offset: 13, flags: DIFlagBitField, extraData: i64 8)
!372 = !DIDerivedType(tag: DW_TAG_member, name: "other", scope: !366, file: !336, line: 48, baseType: !303, size: 1, offset: 14, flags: DIFlagBitField, extraData: i64 8)
!373 = !DIDerivedType(tag: DW_TAG_member, name: "managed", scope: !366, file: !336, line: 49, baseType: !303, size: 1, offset: 15, flags: DIFlagBitField, extraData: i64 8)
!374 = !DIDerivedType(tag: DW_TAG_member, name: "rt_lifetime", scope: !366, file: !336, line: 60, baseType: !214, size: 16, offset: 16)
!375 = !DILocalVariable(name: "i", scope: !376, file: !3, line: 200, type: !54)
!376 = distinct !DILexicalBlock(scope: !139, file: !3, line: 200, column: 9)
!377 = !DILocalVariable(name: "key", scope: !378, file: !3, line: 202, type: !26)
!378 = distinct !DILexicalBlock(scope: !379, file: !3, line: 201, column: 9)
!379 = distinct !DILexicalBlock(scope: !376, file: !3, line: 200, column: 9)
!380 = !DILocalVariable(name: "rule", scope: !378, file: !3, line: 203, type: !381)
!381 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !382, size: 64)
!382 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "settings", file: !3, line: 55, size: 480, elements: !383)
!383 = !{!384, !385}
!384 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !382, file: !3, line: 57, baseType: !169, size: 32)
!385 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !382, file: !3, line: 58, baseType: !161, size: 448, offset: 32)
!386 = !DILocalVariable(name: "check_match", scope: !387, file: !3, line: 211, type: !54)
!387 = distinct !DILexicalBlock(scope: !388, file: !3, line: 210, column: 17)
!388 = distinct !DILexicalBlock(scope: !378, file: !3, line: 209, column: 21)
!389 = !DILocalVariable(name: "packet_ip_processed", scope: !390, file: !3, line: 217, type: !7)
!390 = distinct !DILexicalBlock(scope: !391, file: !3, line: 216, column: 33)
!391 = distinct !DILexicalBlock(scope: !392, file: !3, line: 215, column: 37)
!392 = distinct !DILexicalBlock(scope: !393, file: !3, line: 213, column: 25)
!393 = distinct !DILexicalBlock(scope: !387, file: !3, line: 212, column: 29)
!394 = !DILocalVariable(name: "filter_ip_processed", scope: !390, file: !3, line: 218, type: !7)
!395 = !DILocalVariable(name: "packet_ip_processed", scope: !396, file: !3, line: 234, type: !7)
!396 = distinct !DILexicalBlock(scope: !397, file: !3, line: 233, column: 33)
!397 = distinct !DILexicalBlock(scope: !398, file: !3, line: 232, column: 37)
!398 = distinct !DILexicalBlock(scope: !399, file: !3, line: 231, column: 25)
!399 = distinct !DILexicalBlock(scope: !387, file: !3, line: 230, column: 29)
!400 = !DILocalVariable(name: "filter_ip_processed", scope: !396, file: !3, line: 235, type: !7)
!401 = !DILocation(line: 0, scope: !139)
!402 = !DILocation(line: 100, column: 9, scope: !139)
!403 = !DILocation(line: 100, column: 20, scope: !139)
!404 = !DILocation(line: 101, column: 9, scope: !139)
!405 = !DILocation(line: 103, column: 23, scope: !139)
!406 = !DILocation(line: 103, column: 14, scope: !139)
!407 = !DILocation(line: 103, column: 21, scope: !139)
!408 = !{!409, !413, i64 4}
!409 = !{!"log", !410, i64 0, !410, i64 2, !413, i64 4, !413, i64 12, !414, i64 20}
!410 = !{!"short", !411, i64 0}
!411 = !{!"omnipotent char", !412, i64 0}
!412 = !{!"Simple C/C++ TBAA"}
!413 = !{!"long long", !411, i64 0}
!414 = !{!"tuples", !411, i64 0, !415, i64 4, !415, i64 8, !416, i64 12, !416, i64 28, !411, i64 44, !410, i64 46, !410, i64 48, !410, i64 50, !411, i64 52, !411, i64 53}
!415 = !{!"int", !411, i64 0}
!416 = !{!"in6_addr", !411, i64 0}
!417 = !DILocation(line: 105, column: 49, scope: !139)
!418 = !{!419, !415, i64 0}
!419 = !{!"xdp_md", !415, i64 0, !415, i64 4, !415, i64 8, !415, i64 12, !415, i64 16, !415, i64 20}
!420 = !DILocation(line: 105, column: 38, scope: !139)
!421 = !DILocation(line: 105, column: 30, scope: !139)
!422 = !DILocation(line: 106, column: 23, scope: !423)
!423 = distinct !DILexicalBlock(scope: !139, file: !3, line: 106, column: 13)
!424 = !DILocation(line: 106, column: 45, scope: !423)
!425 = !{!419, !415, i64 4}
!426 = !DILocation(line: 106, column: 40, scope: !423)
!427 = !DILocation(line: 106, column: 38, scope: !423)
!428 = !DILocation(line: 106, column: 13, scope: !139)
!429 = !DILocation(line: 111, column: 18, scope: !218)
!430 = !{!431, !410, i64 12}
!431 = !{!"ethhdr", !411, i64 0, !411, i64 6, !410, i64 12}
!432 = !DILocation(line: 111, column: 13, scope: !139)
!433 = !DILocation(line: 0, scope: !217)
!434 = !DILocation(line: 115, column: 46, scope: !435)
!435 = distinct !DILexicalBlock(scope: !217, file: !3, line: 115, column: 21)
!436 = !DILocation(line: 115, column: 60, scope: !435)
!437 = !DILocation(line: 115, column: 21, scope: !217)
!438 = !DILocation(line: 120, column: 42, scope: !217)
!439 = !{!440, !411, i64 9}
!440 = !{!"iphdr", !415, i64 0, !415, i64 0, !411, i64 1, !410, i64 2, !410, i64 4, !410, i64 6, !411, i64 8, !411, i64 9, !410, i64 10, !415, i64 12, !415, i64 16}
!441 = !DILocation(line: 120, column: 27, scope: !217)
!442 = !DILocation(line: 120, column: 36, scope: !217)
!443 = !{!409, !411, i64 64}
!444 = !DILocation(line: 121, column: 21, scope: !217)
!445 = !DILocation(line: 0, scope: !235)
!446 = !DILocation(line: 124, column: 68, scope: !447)
!447 = distinct !DILexicalBlock(scope: !235, file: !3, line: 124, column: 29)
!448 = !DILocation(line: 124, column: 83, scope: !447)
!449 = !DILocation(line: 124, column: 29, scope: !235)
!450 = !DILocation(line: 123, column: 57, scope: !235)
!451 = !DILocation(line: 128, column: 52, scope: !235)
!452 = !{!453, !410, i64 2}
!453 = !{!"tcphdr", !410, i64 0, !410, i64 2, !415, i64 4, !415, i64 8, !410, i64 12, !410, i64 12, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 13, !410, i64 14, !410, i64 16, !410, i64 18}
!454 = !DILocation(line: 128, column: 35, scope: !235)
!455 = !DILocation(line: 128, column: 45, scope: !235)
!456 = !{!409, !410, i64 68}
!457 = !DILocation(line: 129, column: 51, scope: !235)
!458 = !{!453, !410, i64 0}
!459 = !DILocation(line: 129, column: 35, scope: !235)
!460 = !DILocation(line: 129, column: 44, scope: !235)
!461 = !{!409, !410, i64 66}
!462 = !DILocation(line: 0, scope: !261)
!463 = !DILocation(line: 134, column: 68, scope: !464)
!464 = distinct !DILexicalBlock(scope: !261, file: !3, line: 134, column: 29)
!465 = !DILocation(line: 134, column: 83, scope: !464)
!466 = !DILocation(line: 134, column: 29, scope: !261)
!467 = !DILocation(line: 133, column: 57, scope: !261)
!468 = !DILocation(line: 138, column: 52, scope: !261)
!469 = !{!470, !410, i64 2}
!470 = !{!"udphdr", !410, i64 0, !410, i64 2, !410, i64 4, !410, i64 6}
!471 = !DILocation(line: 138, column: 35, scope: !261)
!472 = !DILocation(line: 138, column: 45, scope: !261)
!473 = !DILocation(line: 139, column: 51, scope: !261)
!474 = !{!470, !410, i64 0}
!475 = !DILocation(line: 139, column: 35, scope: !261)
!476 = !DILocation(line: 139, column: 44, scope: !261)
!477 = !DILocation(line: 0, scope: !272)
!478 = !DILocation(line: 144, column: 68, scope: !479)
!479 = distinct !DILexicalBlock(scope: !272, file: !3, line: 144, column: 29)
!480 = !DILocation(line: 144, column: 84, scope: !479)
!481 = !DILocation(line: 144, column: 29, scope: !272)
!482 = !DILocation(line: 148, column: 65, scope: !272)
!483 = !{!411, !411, i64 0}
!484 = !DILocation(line: 148, column: 35, scope: !272)
!485 = !DILocation(line: 148, column: 49, scope: !272)
!486 = !{!409, !410, i64 70}
!487 = !DILocation(line: 151, column: 40, scope: !217)
!488 = !{!440, !415, i64 12}
!489 = !DILocation(line: 151, column: 27, scope: !217)
!490 = !DILocation(line: 151, column: 34, scope: !217)
!491 = !{!409, !415, i64 24}
!492 = !DILocation(line: 152, column: 41, scope: !217)
!493 = !{!440, !415, i64 16}
!494 = !DILocation(line: 152, column: 27, scope: !217)
!495 = !DILocation(line: 152, column: 35, scope: !217)
!496 = !{!409, !415, i64 28}
!497 = !DILocation(line: 0, scope: !296)
!498 = !DILocation(line: 158, column: 46, scope: !499)
!499 = distinct !DILexicalBlock(scope: !296, file: !3, line: 158, column: 21)
!500 = !DILocation(line: 158, column: 60, scope: !499)
!501 = !DILocation(line: 158, column: 21, scope: !296)
!502 = !DILocation(line: 163, column: 42, scope: !296)
!503 = !{!504, !411, i64 6}
!504 = !{!"ipv6hdr", !411, i64 0, !411, i64 0, !411, i64 1, !410, i64 4, !411, i64 6, !411, i64 7, !411, i64 8}
!505 = !DILocation(line: 163, column: 27, scope: !296)
!506 = !DILocation(line: 163, column: 36, scope: !296)
!507 = !DILocation(line: 164, column: 21, scope: !296)
!508 = !DILocation(line: 0, scope: !326)
!509 = !DILocation(line: 167, column: 68, scope: !510)
!510 = distinct !DILexicalBlock(scope: !326, file: !3, line: 167, column: 29)
!511 = !DILocation(line: 167, column: 83, scope: !510)
!512 = !DILocation(line: 167, column: 29, scope: !326)
!513 = !DILocation(line: 0, scope: !329)
!514 = !DILocation(line: 177, column: 68, scope: !515)
!515 = distinct !DILexicalBlock(scope: !329, file: !3, line: 177, column: 29)
!516 = !DILocation(line: 177, column: 83, scope: !515)
!517 = !DILocation(line: 177, column: 29, scope: !329)
!518 = !DILocation(line: 0, scope: !332)
!519 = !DILocation(line: 187, column: 68, scope: !520)
!520 = distinct !DILexicalBlock(scope: !332, file: !3, line: 187, column: 29)
!521 = !DILocation(line: 187, column: 84, scope: !520)
!522 = !DILocation(line: 0, scope: !327)
!523 = !{!410, !410, i64 0}
!524 = !DILocation(line: 192, column: 27, scope: !296)
!525 = !DILocation(line: 192, column: 41, scope: !296)
!526 = !{i64 0, i64 16, !483, i64 0, i64 16, !483, i64 0, i64 16, !483}
!527 = !DILocation(line: 193, column: 27, scope: !296)
!528 = !DILocation(line: 193, column: 42, scope: !296)
!529 = !DILocation(line: 0, scope: !218)
!530 = !{!409, !411, i64 20}
!531 = !DILocation(line: 0, scope: !376)
!532 = !DILocation(line: 200, column: 9, scope: !376)
!533 = !DILocation(line: 202, column: 17, scope: !378)
!534 = !DILocation(line: 0, scope: !378)
!535 = !DILocation(line: 202, column: 23, scope: !378)
!536 = !{!415, !415, i64 0}
!537 = !DILocation(line: 203, column: 41, scope: !378)
!538 = !DILocation(line: 204, column: 22, scope: !539)
!539 = distinct !DILexicalBlock(scope: !378, file: !3, line: 204, column: 21)
!540 = !DILocation(line: 204, column: 21, scope: !378)
!541 = !DILocation(line: 209, column: 27, scope: !388)
!542 = !{!543, !415, i64 0}
!543 = !{!"settings", !415, i64 0, !414, i64 4}
!544 = !DILocation(line: 209, column: 33, scope: !388)
!545 = !DILocation(line: 209, column: 21, scope: !378)
!546 = !DILocation(line: 0, scope: !387)
!547 = !DILocation(line: 212, column: 40, scope: !393)
!548 = !{!543, !415, i64 8}
!549 = !DILocation(line: 212, column: 47, scope: !393)
!550 = !DILocation(line: 212, column: 29, scope: !387)
!551 = !DILocation(line: 215, column: 48, scope: !391)
!552 = !{!543, !411, i64 56}
!553 = !DILocation(line: 215, column: 60, scope: !391)
!554 = !DILocation(line: 0, scope: !391)
!555 = !DILocation(line: 215, column: 37, scope: !392)
!556 = !DILocation(line: 217, column: 76, scope: !390)
!557 = !DILocation(line: 217, column: 113, scope: !390)
!558 = !DILocation(line: 217, column: 111, scope: !390)
!559 = !DILocation(line: 217, column: 104, scope: !390)
!560 = !DILocation(line: 0, scope: !390)
!561 = !DILocation(line: 218, column: 76, scope: !390)
!562 = !DILocation(line: 218, column: 105, scope: !390)
!563 = !DILocation(line: 220, column: 65, scope: !564)
!564 = distinct !DILexicalBlock(scope: !390, file: !3, line: 220, column: 45)
!565 = !DILocation(line: 220, column: 45, scope: !390)
!566 = !DILocation(line: 224, column: 33, scope: !390)
!567 = !DILocation(line: 225, column: 59, scope: !568)
!568 = distinct !DILexicalBlock(scope: !391, file: !3, line: 225, column: 42)
!569 = !DILocation(line: 225, column: 42, scope: !391)
!570 = !DILocation(line: 228, column: 33, scope: !571)
!571 = distinct !DILexicalBlock(scope: !568, file: !3, line: 226, column: 33)
!572 = !DILocation(line: 230, column: 40, scope: !399)
!573 = !{!543, !415, i64 12}
!574 = !DILocation(line: 230, column: 48, scope: !399)
!575 = !DILocation(line: 230, column: 29, scope: !387)
!576 = !DILocation(line: 232, column: 48, scope: !397)
!577 = !{!543, !411, i64 57}
!578 = !DILocation(line: 232, column: 58, scope: !397)
!579 = !DILocation(line: 0, scope: !397)
!580 = !DILocation(line: 232, column: 37, scope: !398)
!581 = !DILocation(line: 234, column: 76, scope: !396)
!582 = !DILocation(line: 234, column: 114, scope: !396)
!583 = !DILocation(line: 234, column: 112, scope: !396)
!584 = !DILocation(line: 234, column: 105, scope: !396)
!585 = !DILocation(line: 0, scope: !396)
!586 = !DILocation(line: 235, column: 76, scope: !396)
!587 = !DILocation(line: 235, column: 106, scope: !396)
!588 = !DILocation(line: 237, column: 65, scope: !589)
!589 = distinct !DILexicalBlock(scope: !396, file: !3, line: 237, column: 45)
!590 = !DILocation(line: 237, column: 45, scope: !396)
!591 = !DILocation(line: 241, column: 33, scope: !396)
!592 = !DILocation(line: 242, column: 60, scope: !593)
!593 = distinct !DILexicalBlock(scope: !397, file: !3, line: 242, column: 42)
!594 = !DILocation(line: 242, column: 42, scope: !397)
!595 = !DILocation(line: 244, column: 52, scope: !596)
!596 = distinct !DILexicalBlock(scope: !593, file: !3, line: 243, column: 33)
!597 = !DILocation(line: 245, column: 33, scope: !596)
!598 = !DILocation(line: 268, column: 40, scope: !599)
!599 = distinct !DILexicalBlock(scope: !387, file: !3, line: 268, column: 29)
!600 = !{!543, !411, i64 48}
!601 = !DILocation(line: 268, column: 49, scope: !599)
!602 = !DILocation(line: 268, column: 29, scope: !387)
!603 = !DILocation(line: 276, column: 40, scope: !604)
!604 = distinct !DILexicalBlock(scope: !387, file: !3, line: 276, column: 29)
!605 = !{!543, !410, i64 50}
!606 = !DILocation(line: 276, column: 49, scope: !604)
!607 = !DILocation(line: 276, column: 29, scope: !387)
!608 = !DILocation(line: 284, column: 40, scope: !609)
!609 = distinct !DILexicalBlock(scope: !387, file: !3, line: 284, column: 29)
!610 = !{!543, !410, i64 52}
!611 = !DILocation(line: 284, column: 50, scope: !609)
!612 = !DILocation(line: 284, column: 29, scope: !387)
!613 = !DILocation(line: 292, column: 41, scope: !614)
!614 = distinct !DILexicalBlock(scope: !387, file: !3, line: 292, column: 29)
!615 = !DILocation(line: 292, column: 29, scope: !387)
!616 = !DILocation(line: 294, column: 37, scope: !617)
!617 = distinct !DILexicalBlock(scope: !614, file: !3, line: 293, column: 25)
!618 = !DILocalVariable(name: "ctx", arg: 1, scope: !619, file: !3, line: 75, type: !142)
!619 = distinct !DISubprogram(name: "send_perf_event", scope: !3, file: !3, line: 75, type: !620, scopeLine: 76, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !622)
!620 = !DISubroutineType(types: !621)
!621 = !{null, !142, !202}
!622 = !{!618, !623, !624, !625, !626, !629, !630}
!623 = !DILocalVariable(name: "tmp", arg: 2, scope: !619, file: !3, line: 75, type: !202)
!624 = !DILocalVariable(name: "data_end", scope: !619, file: !3, line: 77, type: !21)
!625 = !DILocalVariable(name: "data", scope: !619, file: !3, line: 78, type: !21)
!626 = !DILocalVariable(name: "ret", scope: !627, file: !3, line: 82, type: !54)
!627 = distinct !DILexicalBlock(scope: !628, file: !3, line: 81, column: 9)
!628 = distinct !DILexicalBlock(scope: !619, file: !3, line: 80, column: 13)
!629 = !DILocalVariable(name: "metadata", scope: !627, file: !3, line: 83, type: !202)
!630 = !DILocalVariable(name: "____fmt", scope: !631, file: !3, line: 92, type: !634)
!631 = distinct !DILexicalBlock(scope: !632, file: !3, line: 92, column: 25)
!632 = distinct !DILexicalBlock(scope: !633, file: !3, line: 91, column: 17)
!633 = distinct !DILexicalBlock(scope: !627, file: !3, line: 90, column: 21)
!634 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 144, elements: !635)
!635 = !{!636}
!636 = !DISubrange(count: 18)
!637 = !DILocation(line: 0, scope: !619, inlinedAt: !638)
!638 = distinct !DILocation(line: 300, column: 41, scope: !639)
!639 = distinct !DILexicalBlock(scope: !640, file: !3, line: 299, column: 33)
!640 = distinct !DILexicalBlock(scope: !641, file: !3, line: 298, column: 42)
!641 = distinct !DILexicalBlock(scope: !617, file: !3, line: 294, column: 37)
!642 = !DILocation(line: 77, column: 45, scope: !619, inlinedAt: !638)
!643 = !DILocation(line: 77, column: 34, scope: !619, inlinedAt: !638)
!644 = !DILocation(line: 77, column: 26, scope: !619, inlinedAt: !638)
!645 = !DILocation(line: 78, column: 41, scope: !619, inlinedAt: !638)
!646 = !DILocation(line: 78, column: 30, scope: !619, inlinedAt: !638)
!647 = !DILocation(line: 78, column: 22, scope: !619, inlinedAt: !638)
!648 = !DILocation(line: 80, column: 18, scope: !628, inlinedAt: !638)
!649 = !DILocation(line: 80, column: 13, scope: !619, inlinedAt: !638)
!650 = !DILocation(line: 0, scope: !627, inlinedAt: !638)
!651 = !DILocation(line: 85, column: 27, scope: !627, inlinedAt: !638)
!652 = !DILocation(line: 85, column: 34, scope: !627, inlinedAt: !638)
!653 = !{!409, !410, i64 0}
!654 = !DILocation(line: 86, column: 54, scope: !627, inlinedAt: !638)
!655 = !DILocation(line: 86, column: 37, scope: !627, inlinedAt: !638)
!656 = !DILocation(line: 86, column: 27, scope: !627, inlinedAt: !638)
!657 = !DILocation(line: 86, column: 35, scope: !627, inlinedAt: !638)
!658 = !{!409, !410, i64 2}
!659 = !DILocation(line: 87, column: 37, scope: !627, inlinedAt: !638)
!660 = !DILocation(line: 87, column: 27, scope: !627, inlinedAt: !638)
!661 = !DILocation(line: 87, column: 35, scope: !627, inlinedAt: !638)
!662 = !{!409, !413, i64 12}
!663 = !DILocation(line: 89, column: 45, scope: !627, inlinedAt: !638)
!664 = !DILocation(line: 89, column: 23, scope: !627, inlinedAt: !638)
!665 = !DILocation(line: 90, column: 21, scope: !633, inlinedAt: !638)
!666 = !DILocation(line: 90, column: 21, scope: !627, inlinedAt: !638)
!667 = !DILocation(line: 92, column: 25, scope: !631, inlinedAt: !638)
!668 = !DILocation(line: 92, column: 25, scope: !632, inlinedAt: !638)
!669 = !DILocation(line: 93, column: 17, scope: !632, inlinedAt: !638)
!670 = !DILocation(line: 305, column: 9, scope: !379)
!671 = !DILocation(line: 200, column: 62, scope: !379)
!672 = !DILocation(line: 200, column: 43, scope: !379)
!673 = distinct !{!673, !532, !674, !675}
!674 = !DILocation(line: 305, column: 9, scope: !376)
!675 = !{!"llvm.loop.mustprogress"}
!676 = !DILocation(line: 0, scope: !619, inlinedAt: !677)
!677 = distinct !DILocation(line: 306, column: 9, scope: !139)
!678 = !DILocation(line: 77, column: 45, scope: !619, inlinedAt: !677)
!679 = !DILocation(line: 77, column: 34, scope: !619, inlinedAt: !677)
!680 = !DILocation(line: 77, column: 26, scope: !619, inlinedAt: !677)
!681 = !DILocation(line: 78, column: 41, scope: !619, inlinedAt: !677)
!682 = !DILocation(line: 78, column: 30, scope: !619, inlinedAt: !677)
!683 = !DILocation(line: 78, column: 22, scope: !619, inlinedAt: !677)
!684 = !DILocation(line: 80, column: 18, scope: !628, inlinedAt: !677)
!685 = !DILocation(line: 80, column: 13, scope: !619, inlinedAt: !677)
!686 = !DILocation(line: 0, scope: !627, inlinedAt: !677)
!687 = !DILocation(line: 85, column: 27, scope: !627, inlinedAt: !677)
!688 = !DILocation(line: 85, column: 34, scope: !627, inlinedAt: !677)
!689 = !DILocation(line: 86, column: 54, scope: !627, inlinedAt: !677)
!690 = !DILocation(line: 86, column: 37, scope: !627, inlinedAt: !677)
!691 = !DILocation(line: 86, column: 27, scope: !627, inlinedAt: !677)
!692 = !DILocation(line: 86, column: 35, scope: !627, inlinedAt: !677)
!693 = !DILocation(line: 87, column: 37, scope: !627, inlinedAt: !677)
!694 = !DILocation(line: 87, column: 27, scope: !627, inlinedAt: !677)
!695 = !DILocation(line: 87, column: 35, scope: !627, inlinedAt: !677)
!696 = !DILocation(line: 89, column: 45, scope: !627, inlinedAt: !677)
!697 = !DILocation(line: 89, column: 23, scope: !627, inlinedAt: !677)
!698 = !DILocation(line: 90, column: 21, scope: !633, inlinedAt: !677)
!699 = !DILocation(line: 90, column: 21, scope: !627, inlinedAt: !677)
!700 = !DILocation(line: 92, column: 25, scope: !631, inlinedAt: !677)
!701 = !DILocation(line: 92, column: 25, scope: !632, inlinedAt: !677)
!702 = !DILocation(line: 93, column: 17, scope: !632, inlinedAt: !677)
!703 = !DILocation(line: 308, column: 1, scope: !139)
