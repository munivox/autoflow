(function(){
 const body=document.body, panel=document.querySelector('[data-menu-panel]'), backdrop=document.querySelector('[data-backdrop]');
 const openMenu=()=>{if(panel&&backdrop){panel.classList.add('open');backdrop.classList.add('open');body.classList.add('menu-open')}};
 const closeMenu=()=>{if(panel&&backdrop){panel.classList.remove('open');backdrop.classList.remove('open');body.classList.remove('menu-open')}};
 document.querySelectorAll('[data-menu]').forEach(b=>b.addEventListener('click',openMenu));
 document.querySelectorAll('[data-close-menu]').forEach(b=>b.addEventListener('click',closeMenu));
 if(backdrop)backdrop.addEventListener('click',closeMenu); document.addEventListener('keydown',e=>{if(e.key==='Escape')closeMenu()});
 const modal=document.getElementById('loginModal'); const toast=document.getElementById('toast');
 const closeModal=()=>modal&&modal.classList.remove('open');
 document.querySelectorAll('[data-login]').forEach(b=>b.addEventListener('click',e=>{e.preventDefault();modal&&modal.classList.add('open')}));
 document.querySelectorAll('[data-close]').forEach(b=>b.addEventListener('click',closeModal));
 if(modal)modal.addEventListener('click',e=>{if(e.target===modal)closeModal()});
 document.querySelectorAll('[data-toast]').forEach(b=>b.addEventListener('click',()=>{if(toast){toast.textContent=b.dataset.toast;toast.classList.add('show');setTimeout(()=>toast.classList.remove('show'),3200)} }));
})();

// V15 — cadastro de serviços pelo próprio estabelecimento
(function(){
 const list=document.getElementById('serviceList'); const add=document.querySelector('[data-add-service]'); const count=document.getElementById('serviceCount');
 if(!list||!add)return;
 const update=()=>{const n=list.querySelectorAll('.service-added').length; if(count)count.textContent=n+(n===1?' serviço':' serviços');};
 const open=()=>{
   const card=document.createElement('div'); card.className='service-added-form'; card.innerHTML='<div class="service-form-grid"><div class="field"><label>Nome do serviço</label><input data-sname placeholder="Ex.: Polimento técnico"></div><div class="field"><label>Preço</label><input data-sprice placeholder="R$ 0,00"></div><div class="field"><label>Duração</label><input data-sduration placeholder="Ex.: 90 min"></div></div><div class="field"><label>Descrição</label><textarea data-sdesc placeholder="Explique o que está incluído no serviço."></textarea></div><div class="service-form-actions"><button type="button" class="outline" data-cancel>Cancelar</button><button type="button" class="primary" data-save>Adicionar serviço</button></div>';
   list.replaceChild(card,add);
   card.querySelector('[data-cancel]').onclick=()=>{list.replaceChild(add,card);update()};
   card.querySelector('[data-save]').onclick=()=>{const name=card.querySelector('[data-sname]').value.trim(); if(!name){card.querySelector('[data-sname]').focus();return;} const price=card.querySelector('[data-sprice]').value.trim(); const dur=card.querySelector('[data-sduration]').value.trim(); const desc=card.querySelector('[data-sdesc]').value.trim(); const item=document.createElement('article'); item.className='service-added'; item.innerHTML='<span class="service-dot">✓</span><button type="button" class="remove-service" title="Remover">×</button><strong></strong><small></small><span class="service-price"></span>'; item.querySelector('strong').textContent=name; item.querySelector('small').textContent=desc||'Serviço cadastrado pela empresa'; item.querySelector('.service-price').textContent=[price,dur].filter(Boolean).join(' · ')||'Configurar preço e duração'; item.querySelector('.remove-service').onclick=()=>{item.remove();update()}; list.replaceChild(item,card); list.appendChild(add); update();};
 };
 add.addEventListener('click',open); update();
})();

// V16 — parallax/tilt nos cards, revelação ao rolar e parallax do banner principal
(function(){
  const reduceMotion = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
  const canHover = window.matchMedia && matchMedia('(hover:hover)').matches;

  // Tilt 3D nos cards ao mover o mouse
  if(!reduceMotion && canHover){
    document.querySelectorAll('[data-tilt]').forEach(function(card){
      const max = 5;
      let raf = null;
      card.addEventListener('mousemove', function(e){
        const r = card.getBoundingClientRect();
        const px = (e.clientX - r.left) / r.width - 0.5;
        const py = (e.clientY - r.top) / r.height - 0.5;
        if(raf) cancelAnimationFrame(raf);
        raf = requestAnimationFrame(function(){
          card.style.transform = 'perspective(900px) rotateX(' + (-py * max) + 'deg) rotateY(' + (px * max) + 'deg) translateY(-4px)';
        });
      });
      card.addEventListener('mouseleave', function(){
        if(raf) cancelAnimationFrame(raf);
        card.style.transform = '';
      });
    });
  }

  // Revelação suave dos elementos ao entrar na tela
  const revealEls = document.querySelectorAll('.reveal');
  if(revealEls.length){
    if('IntersectionObserver' in window && !reduceMotion){
      const io = new IntersectionObserver(function(entries){
        entries.forEach(function(entry){
          if(entry.isIntersecting){ entry.target.classList.add('in'); io.unobserve(entry.target); }
        });
      }, {threshold: .12, rootMargin: '0px 0px -40px 0px'});
      revealEls.forEach(function(el){ io.observe(el); });
    } else {
      revealEls.forEach(function(el){ el.classList.add('in'); });
    }
  }

  // Parallax leve na foto do banner principal ao rolar
  const heroPhoto = document.querySelector('.af-hero-photo');
  if(heroPhoto && !reduceMotion){
    let ticking = false;
    window.addEventListener('scroll', function(){
      if(!ticking){
        requestAnimationFrame(function(){
          const y = Math.min(window.scrollY * 0.18, 90);
          heroPhoto.style.transform = 'translateY(' + y + 'px) scale(1.06)';
          ticking = false;
        });
        ticking = true;
      }
    }, {passive:true});
  }
})();
