; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.lpm_v4_key = type { i32, i32 }
%struct.flow = type <{ i32, i32, i32, double }>
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@logger = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 20000, i32 2, i32 0 }, section "maps", align 4, !dbg !0
@blacklist = dso_local global %struct.bpf_map_def { i32 11, i32 8, i32 4, i32 1000000, i32 1 }, section "maps", align 4, !dbg !21
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !31
@llvm.compiler.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @logger to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_filter_func to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_filter_func(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp_filter" !dbg !114 {
  %2 = alloca %struct.lpm_v4_key, align 4
  %3 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !128, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.value(metadata i32 0, metadata !129, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !196
  call void @llvm.dbg.value(metadata i32 0, metadata !129, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !196
  call void @llvm.dbg.value(metadata %struct.flow* undef, metadata !176, metadata !DIExpression()), !dbg !196
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !197
  %5 = load i32, i32* %4, align 4, !dbg !197, !tbaa !198
  %6 = zext i32 %5 to i64, !dbg !203
  %7 = inttoptr i64 %6 to i8*, !dbg !204
  call void @llvm.dbg.value(metadata i8* %7, metadata !140, metadata !DIExpression()), !dbg !196
  %8 = add nuw nsw i64 %6, 14, !dbg !205
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !207
  %10 = load i32, i32* %9, align 4, !dbg !207, !tbaa !208
  %11 = zext i32 %10 to i64, !dbg !209
  %12 = icmp ugt i64 %8, %11, !dbg !210
  br i1 %12, label %58, label %13, !dbg !211

13:                                               ; preds = %1
  %14 = inttoptr i64 %6 to %struct.ethhdr*, !dbg !204
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !140, metadata !DIExpression()), !dbg !196
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 2, !dbg !212
  %16 = load i16, i16* %15, align 1, !dbg !212, !tbaa !213
  %17 = icmp eq i16 %16, 8, !dbg !216
  br i1 %17, label %18, label %58, !dbg !217

18:                                               ; preds = %13
  call void @llvm.dbg.value(metadata i8* %7, metadata !154, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !196
  %19 = add nuw nsw i64 %6, 34, !dbg !218
  %20 = icmp ugt i64 %19, %11, !dbg !220
  br i1 %20, label %58, label %21, !dbg !221

21:                                               ; preds = %18
  call void @llvm.dbg.value(metadata i8* %7, metadata !154, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !196
  call void @llvm.dbg.value(metadata i8* %7, metadata !154, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !196
  %22 = getelementptr i8, i8* %7, i64 26, !dbg !222
  %23 = bitcast i8* %22 to i32*, !dbg !222
  %24 = load i32, i32* %23, align 4, !dbg !222
  call void @llvm.dbg.value(metadata i32 %24, metadata !129, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !196
  %25 = getelementptr i8, i8* %7, i64 30, !dbg !223
  %26 = bitcast i8* %25 to i32*, !dbg !223
  %27 = load i32, i32* %26, align 4, !dbg !223, !tbaa !224
  call void @llvm.dbg.value(metadata i32 %27, metadata !129, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !196
  %28 = bitcast %struct.lpm_v4_key* %2 to i8*, !dbg !226
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %28) #4, !dbg !226
  call void @llvm.dbg.declare(metadata %struct.lpm_v4_key* %2, metadata !178, metadata !DIExpression()), !dbg !227
  %29 = getelementptr inbounds %struct.lpm_v4_key, %struct.lpm_v4_key* %2, i64 0, i32 1, !dbg !228
  store i32 %24, i32* %29, align 4, !dbg !229
  %30 = getelementptr inbounds %struct.lpm_v4_key, %struct.lpm_v4_key* %2, i64 0, i32 0, !dbg !230
  store i32 32, i32* %30, align 4, !dbg !231, !tbaa !232
  %31 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* noundef nonnull %28) #4, !dbg !234
  %32 = icmp eq i8* %31, null, !dbg !234
  br i1 %32, label %34, label %33, !dbg !236

33:                                               ; preds = %21
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %28) #4, !dbg !237
  br label %58

34:                                               ; preds = %21
  %35 = bitcast i32* %3 to i8*, !dbg !238
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #4, !dbg !238
  call void @llvm.dbg.value(metadata i32 1, metadata !185, metadata !DIExpression()), !dbg !239
  store i32 1, i32* %3, align 4, !dbg !240, !tbaa !241
  call void @llvm.dbg.value(metadata i32* %3, metadata !185, metadata !DIExpression(DW_OP_deref)), !dbg !239
  %36 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.bpf_map_def* @logger to i8*), i8* noundef nonnull %35) #4, !dbg !242
  call void @llvm.dbg.value(metadata i8* %36, metadata !186, metadata !DIExpression()), !dbg !239
  %37 = icmp eq i8* %36, null, !dbg !243
  br i1 %37, label %57, label %38, !dbg !245

38:                                               ; preds = %34
  %39 = bitcast i8* %36 to [1000 x %struct.flow]*
  call void @llvm.dbg.value(metadata i32 0, metadata !194, metadata !DIExpression()), !dbg !246
  br label %43, !dbg !247

40:                                               ; preds = %51
  %41 = add nuw nsw i64 %44, 1, !dbg !248
  call void @llvm.dbg.value(metadata i64 %41, metadata !194, metadata !DIExpression()), !dbg !246
  call void @llvm.dbg.value(metadata i64 %44, metadata !194, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !246
  %42 = icmp eq i64 %41, 1000, !dbg !250
  br i1 %42, label %56, label %43, !dbg !247, !llvm.loop !251

43:                                               ; preds = %38, %40
  %44 = phi i64 [ 0, %38 ], [ %41, %40 ]
  call void @llvm.dbg.value(metadata i64 %44, metadata !194, metadata !DIExpression()), !dbg !246
  %45 = getelementptr inbounds [1000 x %struct.flow], [1000 x %struct.flow]* %39, i64 0, i64 %44, i32 0, !dbg !254
  %46 = load i32, i32* %45, align 1, !dbg !254, !tbaa !257
  %47 = icmp eq i32 %46, %24, !dbg !260
  br i1 %47, label %48, label %51, !dbg !261

48:                                               ; preds = %43
  %49 = getelementptr inbounds [1000 x %struct.flow], [1000 x %struct.flow]* %39, i64 0, i64 %44, i32 2, !dbg !262
  %50 = atomicrmw add i32* %49, i32 1 seq_cst, align 4, !dbg !262
  br label %56, !dbg !264

51:                                               ; preds = %43
  %52 = icmp eq i32 %46, 0, !dbg !265
  call void @llvm.dbg.value(metadata i64 %44, metadata !194, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !246
  br i1 %52, label %53, label %40, !dbg !267

53:                                               ; preds = %51
  store i32 %24, i32* %45, align 1, !dbg !268, !tbaa !257
  %54 = getelementptr inbounds [1000 x %struct.flow], [1000 x %struct.flow]* %39, i64 0, i64 %44, i32 1, !dbg !270
  store i32 %27, i32* %54, align 1, !dbg !271, !tbaa !272
  %55 = getelementptr inbounds [1000 x %struct.flow], [1000 x %struct.flow]* %39, i64 0, i64 %44, i32 2, !dbg !273
  store i32 1, i32* %55, align 1, !dbg !274, !tbaa !275
  br label %56, !dbg !276

56:                                               ; preds = %40, %53, %48
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #4, !dbg !237
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %28) #4, !dbg !237
  br label %58

57:                                               ; preds = %34
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #4, !dbg !237
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %28) #4, !dbg !237
  br label %58

58:                                               ; preds = %13, %56, %57, %33, %18, %1
  %59 = phi i32 [ 2, %57 ], [ 1, %1 ], [ 1, %18 ], [ 1, %33 ], [ 2, %56 ], [ 2, %13 ], !dbg !196
  ret i32 %59, !dbg !277
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!109, !110, !111, !112}
!llvm.ident = !{!113}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "logger", scope: !2, file: !3, line: 45, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/mirai/ebpf_pfilt/domex", checksumkind: CSK_MD5, checksum: "4ea87a27f9d1c0eedaf6b1b4364be347")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 5431, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "5ad8bc925dae1ec87bbb04b3148b183b")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15, !16, !17}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !{!0, !21, !31, !37, !99, !101}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "blacklist", scope: !2, file: !3, line: 52, type: !23, isLocal: false, isDefinition: true)
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !24, line: 33, size: 160, elements: !25)
!24 = !DIFile(filename: "./libbpf/src/bpf_helpers.h", directory: "/home/mirai/ebpf_pfilt/domex", checksumkind: CSK_MD5, checksum: "9e37b5f46a8fb7f5ed35ab69309bf15d")
!25 = !{!26, !27, !28, !29, !30}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !23, file: !24, line: 34, baseType: !7, size: 32)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !23, file: !24, line: 35, baseType: !7, size: 32, offset: 32)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !23, file: !24, line: 36, baseType: !7, size: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !23, file: !24, line: 37, baseType: !7, size: 32, offset: 96)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !23, file: !24, line: 38, baseType: !7, size: 32, offset: 128)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 207, type: !33, isLocal: false, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 32, elements: !35)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 4)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !39, line: 143, type: !40, isLocal: false, isDefinition: false)
!39 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "f31eefcc3f15835fc5a4023a625cf609")
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !42, line: 7, baseType: !43)
!42 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "571f9fb6223c42439075fdde11a0de5d")
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !44, line: 49, size: 1728, elements: !45)
!44 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types/struct_FILE.h", directory: "", checksumkind: CSK_MD5, checksum: "1bad07471b7974df4ecc1d1c2ca207e6")
!45 = !{!46, !48, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !63, !65, !66, !67, !70, !71, !73, !77, !80, !82, !85, !88, !89, !90, !94, !95}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !43, file: !44, line: 51, baseType: !47, size: 32)
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !43, file: !44, line: 54, baseType: !49, size: 64, offset: 64)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !43, file: !44, line: 55, baseType: !49, size: 64, offset: 128)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !43, file: !44, line: 56, baseType: !49, size: 64, offset: 192)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !43, file: !44, line: 57, baseType: !49, size: 64, offset: 256)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !43, file: !44, line: 58, baseType: !49, size: 64, offset: 320)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !43, file: !44, line: 59, baseType: !49, size: 64, offset: 384)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !43, file: !44, line: 60, baseType: !49, size: 64, offset: 448)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !43, file: !44, line: 61, baseType: !49, size: 64, offset: 512)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !43, file: !44, line: 64, baseType: !49, size: 64, offset: 576)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !43, file: !44, line: 65, baseType: !49, size: 64, offset: 640)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !43, file: !44, line: 66, baseType: !49, size: 64, offset: 704)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !43, file: !44, line: 68, baseType: !61, size: 64, offset: 768)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !44, line: 36, flags: DIFlagFwdDecl)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !43, file: !44, line: 70, baseType: !64, size: 64, offset: 832)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !43, file: !44, line: 72, baseType: !47, size: 32, offset: 896)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !43, file: !44, line: 73, baseType: !47, size: 32, offset: 928)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !43, file: !44, line: 74, baseType: !68, size: 64, offset: 960)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !69, line: 152, baseType: !16)
!69 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !43, file: !44, line: 77, baseType: !19, size: 16, offset: 1024)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !43, file: !44, line: 78, baseType: !72, size: 8, offset: 1040)
!72 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !43, file: !44, line: 79, baseType: !74, size: 8, offset: 1048)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 8, elements: !75)
!75 = !{!76}
!76 = !DISubrange(count: 1)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !43, file: !44, line: 81, baseType: !78, size: 64, offset: 1088)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !44, line: 43, baseType: null)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !43, file: !44, line: 89, baseType: !81, size: 64, offset: 1152)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !69, line: 153, baseType: !16)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !43, file: !44, line: 91, baseType: !83, size: 64, offset: 1216)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !44, line: 37, flags: DIFlagFwdDecl)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !43, file: !44, line: 92, baseType: !86, size: 64, offset: 1280)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !44, line: 38, flags: DIFlagFwdDecl)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !43, file: !44, line: 93, baseType: !64, size: 64, offset: 1344)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !43, file: !44, line: 94, baseType: !15, size: 64, offset: 1408)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !43, file: !44, line: 95, baseType: !91, size: 64, offset: 1472)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !92, line: 46, baseType: !93)
!92 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!93 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !43, file: !44, line: 96, baseType: !47, size: 32, offset: 1536)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !43, file: !44, line: 98, baseType: !96, size: 160, offset: 1568)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 160, elements: !97)
!97 = !{!98}
!98 = !DISubrange(count: 20)
!99 = !DIGlobalVariableExpression(var: !100, expr: !DIExpression())
!100 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !39, line: 144, type: !40, isLocal: false, isDefinition: false)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !103, line: 33, type: !104, isLocal: true, isDefinition: true)
!103 = !DIFile(filename: "./libbpf/src/bpf_helper_defs.h", directory: "/home/mirai/ebpf_pfilt/domex", checksumkind: CSK_MD5, checksum: "2601bcf9d7985cb46bfbd904b60f5aaf")
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = !DISubroutineType(types: !106)
!106 = !{!15, !15, !107}
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!109 = !{i32 7, !"Dwarf Version", i32 5}
!110 = !{i32 2, !"Debug Info Version", i32 3}
!111 = !{i32 1, !"wchar_size", i32 4}
!112 = !{i32 7, !"frame-pointer", i32 2}
!113 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!114 = distinct !DISubprogram(name: "xdp_filter_func", scope: !3, file: !3, line: 90, type: !115, scopeLine: 91, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !127)
!115 = !DISubroutineType(types: !116)
!116 = !{!47, !117}
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 5442, size: 192, elements: !119)
!119 = !{!120, !122, !123, !124, !125, !126}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !118, file: !6, line: 5443, baseType: !121, size: 32)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !18, line: 27, baseType: !7)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !118, file: !6, line: 5444, baseType: !121, size: 32, offset: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !118, file: !6, line: 5445, baseType: !121, size: 32, offset: 64)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !118, file: !6, line: 5447, baseType: !121, size: 32, offset: 96)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !118, file: !6, line: 5448, baseType: !121, size: 32, offset: 128)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !118, file: !6, line: 5450, baseType: !121, size: 32, offset: 160)
!127 = !{!128, !129, !140, !154, !176, !178, !185, !186, !194}
!128 = !DILocalVariable(name: "ctx", arg: 1, scope: !114, file: !3, line: 90, type: !117)
!129 = !DILocalVariable(name: "tm", scope: !114, file: !3, line: 101, type: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flow", file: !3, line: 20, size: 160, elements: !131)
!131 = !{!132, !136, !137, !138}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "ip_src", scope: !130, file: !3, line: 22, baseType: !133, size: 32)
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "u_int32_t", file: !134, line: 160, baseType: !135)
!134 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/sys/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e62424071ad3f1b4d088c139fd9ccfd1")
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !69, line: 42, baseType: !7)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ip_dest", scope: !130, file: !3, line: 23, baseType: !133, size: 32, offset: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "packet_count", scope: !130, file: !3, line: 24, baseType: !121, size: 32, offset: 64)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "entropy", scope: !130, file: !3, line: 25, baseType: !139, size: 64, offset: 96)
!139 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!140 = !DILocalVariable(name: "eth", scope: !114, file: !3, line: 102, type: !141)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !143, line: 168, size: 112, elements: !144)
!143 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!144 = !{!145, !150, !151}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !142, file: !143, line: 169, baseType: !146, size: 48)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !147, size: 48, elements: !148)
!147 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!148 = !{!149}
!149 = !DISubrange(count: 6)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !142, file: !143, line: 170, baseType: !146, size: 48, offset: 48)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !142, file: !143, line: 171, baseType: !152, size: 16, offset: 96)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !153, line: 25, baseType: !17)
!153 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!154 = !DILocalVariable(name: "ip", scope: !114, file: !3, line: 103, type: !155)
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!156 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !157, line: 44, size: 160, elements: !158)
!157 = !DIFile(filename: "/usr/include/netinet/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "777a3c26c651c3cea644451d8391a76c")
!158 = !{!159, !160, !161, !165, !168, !169, !170, !171, !172, !173, !175}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !156, file: !157, line: 47, baseType: !7, size: 4, flags: DIFlagBitField, extraData: i64 0)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !156, file: !157, line: 48, baseType: !7, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !156, file: !157, line: 55, baseType: !162, size: 8, offset: 8)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !163, line: 24, baseType: !164)
!163 = !DIFile(filename: "/usr/include/aarch64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !69, line: 38, baseType: !147)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !156, file: !157, line: 56, baseType: !166, size: 16, offset: 16)
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !163, line: 25, baseType: !167)
!167 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !69, line: 40, baseType: !19)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !156, file: !157, line: 57, baseType: !166, size: 16, offset: 32)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !156, file: !157, line: 58, baseType: !166, size: 16, offset: 48)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !156, file: !157, line: 59, baseType: !162, size: 8, offset: 64)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !156, file: !157, line: 60, baseType: !162, size: 8, offset: 72)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !156, file: !157, line: 61, baseType: !166, size: 16, offset: 80)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !156, file: !157, line: 62, baseType: !174, size: 32, offset: 96)
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !163, line: 26, baseType: !135)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !156, file: !157, line: 63, baseType: !174, size: 32, offset: 128)
!176 = !DILocalVariable(name: "tmp", scope: !114, file: !3, line: 105, type: !177)
!177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!178 = !DILocalVariable(name: "key", scope: !179, file: !3, line: 131, type: !181)
!179 = distinct !DILexicalBlock(scope: !180, file: !3, line: 117, column: 9)
!180 = distinct !DILexicalBlock(scope: !114, file: !3, line: 116, column: 13)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lpm_v4_key", file: !3, line: 33, size: 64, elements: !182)
!182 = !{!183, !184}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "prefixlen", scope: !181, file: !3, line: 35, baseType: !121, size: 32)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "address", scope: !181, file: !3, line: 36, baseType: !121, size: 32, offset: 32)
!185 = !DILocalVariable(name: "invl_index", scope: !179, file: !3, line: 140, type: !121)
!186 = !DILocalVariable(name: "invl", scope: !179, file: !3, line: 141, type: !187)
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!188 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "interval", file: !3, line: 28, size: 160000, elements: !189)
!189 = !{!190}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "flow", scope: !188, file: !3, line: 30, baseType: !191, size: 160000)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !130, size: 160000, elements: !192)
!192 = !{!193}
!193 = !DISubrange(count: 1000)
!194 = !DILocalVariable(name: "i", scope: !195, file: !3, line: 177, type: !47)
!195 = distinct !DILexicalBlock(scope: !179, file: !3, line: 177, column: 17)
!196 = !DILocation(line: 0, scope: !114)
!197 = !DILocation(line: 108, column: 34, scope: !114)
!198 = !{!199, !200, i64 0}
!199 = !{!"xdp_md", !200, i64 0, !200, i64 4, !200, i64 8, !200, i64 12, !200, i64 16, !200, i64 20}
!200 = !{!"int", !201, i64 0}
!201 = !{!"omnipotent char", !202, i64 0}
!202 = !{!"Simple C/C++ TBAA"}
!203 = !DILocation(line: 108, column: 23, scope: !114)
!204 = !DILocation(line: 108, column: 15, scope: !114)
!205 = !DILocation(line: 110, column: 23, scope: !206)
!206 = distinct !DILexicalBlock(scope: !114, file: !3, line: 110, column: 13)
!207 = !DILocation(line: 110, column: 45, scope: !206)
!208 = !{!199, !200, i64 4}
!209 = !DILocation(line: 110, column: 40, scope: !206)
!210 = !DILocation(line: 110, column: 38, scope: !206)
!211 = !DILocation(line: 110, column: 13, scope: !114)
!212 = !DILocation(line: 116, column: 18, scope: !180)
!213 = !{!214, !215, i64 12}
!214 = !{!"ethhdr", !201, i64 0, !201, i64 6, !215, i64 12}
!215 = !{!"short", !201, i64 0}
!216 = !DILocation(line: 116, column: 26, scope: !180)
!217 = !DILocation(line: 116, column: 13, scope: !114)
!218 = !DILocation(line: 121, column: 46, scope: !219)
!219 = distinct !DILexicalBlock(scope: !179, file: !3, line: 121, column: 21)
!220 = !DILocation(line: 121, column: 60, scope: !219)
!221 = !DILocation(line: 121, column: 21, scope: !179)
!222 = !DILocation(line: 127, column: 35, scope: !179)
!223 = !DILocation(line: 128, column: 36, scope: !179)
!224 = !{!225, !200, i64 16}
!225 = !{!"iphdr", !200, i64 0, !200, i64 0, !201, i64 1, !215, i64 2, !215, i64 4, !215, i64 6, !201, i64 8, !201, i64 9, !215, i64 10, !200, i64 12, !200, i64 16}
!226 = !DILocation(line: 131, column: 17, scope: !179)
!227 = !DILocation(line: 131, column: 35, scope: !179)
!228 = !DILocation(line: 132, column: 39, scope: !179)
!229 = !DILocation(line: 132, column: 17, scope: !179)
!230 = !DILocation(line: 133, column: 21, scope: !179)
!231 = !DILocation(line: 133, column: 31, scope: !179)
!232 = !{!233, !200, i64 0}
!233 = !{!"lpm_v4_key", !200, i64 0, !200, i64 4}
!234 = !DILocation(line: 134, column: 21, scope: !235)
!235 = distinct !DILexicalBlock(scope: !179, file: !3, line: 134, column: 21)
!236 = !DILocation(line: 134, column: 21, scope: !179)
!237 = !DILocation(line: 203, column: 9, scope: !180)
!238 = !DILocation(line: 140, column: 17, scope: !179)
!239 = !DILocation(line: 0, scope: !179)
!240 = !DILocation(line: 140, column: 23, scope: !179)
!241 = !{!200, !200, i64 0}
!242 = !DILocation(line: 141, column: 41, scope: !179)
!243 = !DILocation(line: 142, column: 22, scope: !244)
!244 = distinct !DILexicalBlock(scope: !179, file: !3, line: 142, column: 21)
!245 = !DILocation(line: 142, column: 21, scope: !179)
!246 = !DILocation(line: 0, scope: !195)
!247 = !DILocation(line: 177, column: 17, scope: !195)
!248 = !DILocation(line: 177, column: 44, scope: !249)
!249 = distinct !DILexicalBlock(scope: !195, file: !3, line: 177, column: 17)
!250 = !DILocation(line: 177, column: 35, scope: !249)
!251 = distinct !{!251, !247, !252, !253}
!252 = !DILocation(line: 199, column: 17, scope: !195)
!253 = !{!"llvm.loop.mustprogress"}
!254 = !DILocation(line: 179, column: 43, scope: !255)
!255 = distinct !DILexicalBlock(scope: !256, file: !3, line: 179, column: 29)
!256 = distinct !DILexicalBlock(scope: !249, file: !3, line: 178, column: 17)
!257 = !{!258, !200, i64 0}
!258 = !{!"flow", !200, i64 0, !200, i64 4, !200, i64 8, !259, i64 12}
!259 = !{!"double", !201, i64 0}
!260 = !DILocation(line: 179, column: 50, scope: !255)
!261 = !DILocation(line: 179, column: 29, scope: !256)
!262 = !DILocation(line: 183, column: 41, scope: !263)
!263 = distinct !DILexicalBlock(scope: !255, file: !3, line: 180, column: 25)
!264 = !DILocation(line: 186, column: 33, scope: !263)
!265 = !DILocation(line: 188, column: 55, scope: !266)
!266 = distinct !DILexicalBlock(scope: !255, file: !3, line: 188, column: 34)
!267 = !DILocation(line: 188, column: 34, scope: !255)
!268 = !DILocation(line: 193, column: 62, scope: !269)
!269 = distinct !DILexicalBlock(scope: !266, file: !3, line: 189, column: 25)
!270 = !DILocation(line: 194, column: 55, scope: !269)
!271 = !DILocation(line: 194, column: 63, scope: !269)
!272 = !{!258, !200, i64 4}
!273 = !DILocation(line: 195, column: 55, scope: !269)
!274 = !DILocation(line: 195, column: 68, scope: !269)
!275 = !{!258, !200, i64 8}
!276 = !DILocation(line: 196, column: 41, scope: !269)
!277 = !DILocation(line: 205, column: 1, scope: !114)
