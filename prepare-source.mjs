import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');
const p=JSON.parse(readFileSync('reviewed-source.json'));
assert.equal(p.base,'a24e70498cae2c891b25a0b700b3d1769bdb4ea9');
const run=(exe,args)=>execFileSync(exe,args,{encoding:'utf8',maxBuffer:64e6,stdio:['pipe','pipe','pipe']});
assert.equal(run('calcit',['-v']).trim(),'0.30.1');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):norm(x)])):v;
const q=(...a)=>{const r=JSON.parse(run('calcit',['calcit.cirru','query',...a,'--format','json']));assert.ok(!r.diagnostics?.some(d=>d.severity==='error'));return norm(r.data);};
function views(){const namespaces=[],defs=[];for(const n of q('ns').namespaces){const info=q('ns',n);namespaces.push(info);const names=run('calcit',['calcit.cirru','query','defs',n]).split('\n').filter(l=>/^  \S/.test(l)).map(l=>l.trim().split(' ')[0]);assert.equal(names.length,info.definition_count);for(const d of names)defs.push(q('def',n+'/'+d));}return {config:q('config'),namespaces,defs};}
mkdirSync('acceptance',{recursive:true});
assert.equal(run('git',['hash-object','calcit.cirru']).trim(),p.blob);assert.deepEqual(views(),norm(p.before));
for(const[f,s]of Object.entries(p.manifests))assert.equal(readFileSync(f,'utf8'),s);
const oldLock=run('git',['show',p.base+':yarn.lock']);
const runtimeOnly=s=>s.replace(/"@calcit\/procs@npm:[^"]+":\n(?:  .*\n|\n)*?(?=\S|$)/g,'__PROC_BLOCK__\n').replace(/"@calcit\/procs": "npm:[^"]+"/g,'"@calcit/procs": "npm:RUNTIME"');
assert.equal(runtimeOnly(readFileSync('yarn.lock','utf8')),runtimeOnly(oldLock));
run('git',['diff','--exit-code',p.base,'--','shaders','README.md','.github/workflows/upload.yaml']);
writeFileSync('acceptance/source-evidence.json',JSON.stringify({beforeBlob:p.blob,afterBlob:p.blob,definitions:43,attachedTests:0,fullSourceViewsUnchanged:true,runtimeOnlyLock:true,shadersUnchanged:true}));
